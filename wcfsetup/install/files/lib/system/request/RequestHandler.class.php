<?php

namespace wcf\system\request;

use Laminas\Diactoros\Response\RedirectResponse;
use Laminas\Diactoros\ServerRequestFactory;
use Laminas\HttpHandlerRunner\Emitter\SapiEmitter;
use Psr\Http\Message\RequestInterface;
use Psr\Http\Message\ResponseInterface;
use wcf\http\LegacyPlaceholderResponse;
use wcf\http\middleware\AddAcpSecurityHeaders;
use wcf\http\middleware\CheckForEnterpriseNonOwnerAccess;
use wcf\http\middleware\CheckForExpiredAppEvaluation;
use wcf\http\middleware\CheckForOfflineMode;
use wcf\http\middleware\CheckSystemEnvironment;
use wcf\http\middleware\EnforceCacheControlPrivate;
use wcf\http\middleware\EnforceFrameOptions;
use wcf\http\Pipeline;
use wcf\system\application\ApplicationHandler;
use wcf\system\exception\AJAXException;
use wcf\system\exception\IllegalLinkException;
use wcf\system\exception\NamedUserException;
use wcf\system\exception\SystemException;
use wcf\system\SingletonFactory;
use wcf\system\WCF;
use wcf\util\HeaderUtil;

/**
 * Handles http requests.
 *
 * @author  Marcel Werk
 * @copyright   2001-2022 WoltLab GmbH
 * @license GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package WoltLabSuite\Core\System\Request
 */
final class RequestHandler extends SingletonFactory
{
    /**
     * active request object
     * @var Request
     */
    protected $activeRequest;

    /**
     * indicates if the request is an acp request
     * @var bool
     */
    protected $isACPRequest = false;

    /**
     * @inheritDoc
     */
    protected function init()
    {
        $this->isACPRequest = \class_exists('wcf\system\WCFACP', false);
    }

    /**
     * Handles a http request.
     *
     * @param string $application
     * @param bool $isACPRequest
     * @throws  AJAXException
     * @throws  IllegalLinkException
     * @throws  SystemException
     */
    public function handle($application = 'wcf', $isACPRequest = false)
    {
        try {
            $this->isACPRequest = $isACPRequest;

            if (!RouteHandler::getInstance()->matches()) {
                if (ENABLE_DEBUG_MODE) {
                    throw new SystemException("Cannot handle request, no valid route provided.");
                } else {
                    throw new IllegalLinkException();
                }
            }

            $psrRequest = ServerRequestFactory::fromGlobals();

            $builtRequest = $this->buildRequest($psrRequest, $application);

            if ($builtRequest instanceof Request) {
                $this->activeRequest = $builtRequest;

                $pipeline = new Pipeline([
                    new AddAcpSecurityHeaders(),
                    new EnforceCacheControlPrivate(),
                    new EnforceFrameOptions(),
                    new CheckSystemEnvironment(),
                    new CheckForEnterpriseNonOwnerAccess(),
                    new CheckForExpiredAppEvaluation(),
                    new CheckForOfflineMode(),
                ]);

                $response = $pipeline->process($psrRequest, $this->getActiveRequest());

                if ($response instanceof LegacyPlaceholderResponse) {
                    return;
                }
            } else {
                \assert($builtRequest instanceof ResponseInterface);
                $response = $builtRequest;
            }

            $emitter = new SapiEmitter();
            $emitter->emit($response);
        } catch (NamedUserException $e) {
            $e->show();

            exit;
        }
    }

    /**
     * Builds a new request.
     *
     * @throws  IllegalLinkException
     * @throws  NamedUserException
     * @throws  SystemException
     */
    protected function buildRequest(RequestInterface $psrRequest, string $application): Request|ResponseInterface
    {
        try {
            $routeData = RouteHandler::getInstance()->getRouteData();

            \assert(RouteHandler::getInstance()->isDefaultController() || $routeData['controller']);

            if ($this->isACPRequest()) {
                if (empty($routeData['controller'])) {
                    $routeData['controller'] = 'index';

                    if ($application !== 'wcf') {
                        return new RedirectResponse(
                            LinkHandler::getInstance()->getLink(),
                            301
                        );
                    }
                }
            } else {
                // handle landing page for frontend requests
                if (RouteHandler::getInstance()->isDefaultController()) {
                    $data = ControllerMap::getInstance()->lookupDefaultController($application);

                    // copy route data
                    foreach ($data as $key => $value) {
                        $routeData[$key] = $value;
                    }

                    $routeData['isDefaultController'] = true;
                }

                // check if accessing from the wrong domain (e.g. "www." omitted but domain was configured with)
                $domainName = ApplicationHandler::getInstance()->getDomainName();
                if ($domainName !== $psrRequest->getUri()->getHost()) {
                    $targetUrl = $psrRequest->getUri()->withHost($domainName);

                    return new RedirectResponse(
                        $targetUrl,
                        301
                    );
                }
            }

            if (isset($routeData['className'])) {
                $className = $routeData['className'];
            } else {
                $controller = $routeData['controller'];

                $classApplication = $application;
                if (
                    !empty($routeData['isDefaultController'])
                    && !empty($routeData['application'])
                    && $routeData['application'] !== $application
                ) {
                    $classApplication = $routeData['application'];
                }

                $classData = ControllerMap::getInstance()->resolve(
                    $classApplication,
                    $controller,
                    $this->isACPRequest(),
                    RouteHandler::getInstance()->isRenamedController()
                );
                if (\is_string($classData)) {
                    $this->redirect($routeData, $application, $classData);
                } else {
                    $className = $classData['className'];
                }
            }

            // handle CMS page meta data
            $metaData = ['isDefaultController' => (!empty($routeData['isDefaultController']))];
            if (isset($routeData['cmsPageID'])) {
                $metaData['cms'] = [
                    'pageID' => $routeData['cmsPageID'],
                    'languageID' => $routeData['cmsPageLanguageID'],
                ];

                if (
                    $routeData['cmsPageLanguageID']
                    && $routeData['cmsPageLanguageID'] != WCF::getLanguage()->languageID
                ) {
                    WCF::setLanguage($routeData['cmsPageLanguageID']);
                }
            }

            return new Request(
                $className,
                $metaData,
                !$this->isACPRequest() && ControllerMap::getInstance()->isLandingPage($className, $metaData)
            );
        } catch (SystemException $e) {
            if (
                \defined('ENABLE_DEBUG_MODE')
                && ENABLE_DEBUG_MODE
                && \defined('ENABLE_DEVELOPER_TOOLS')
                && ENABLE_DEVELOPER_TOOLS
            ) {
                throw $e;
            }

            throw new IllegalLinkException();
        }
    }

    /**
     * Redirects to the actual URL, e.g. controller has been aliased or mistyped (boardlist instead of board-list).
     *
     * @param string[] $routeData
     */
    protected function redirect(array $routeData, string $application, string $controller)
    {
        $routeData['application'] = $application;
        $routeData['controller'] = $controller;

        // append the remaining query parameters
        foreach ($_GET as $key => $value) {
            if (!empty($value) && $key != 'controller') {
                $routeData[$key] = $value;
            }
        }

        $redirectURL = LinkHandler::getInstance()->getLink($routeData['controller'], $routeData);
        HeaderUtil::redirect($redirectURL, true, false);

        exit;
    }

    /**
     * Returns the active request object.
     *
     * @return  Request
     */
    public function getActiveRequest()
    {
        return $this->activeRequest;
    }

    /**
     * Returns true if the request is an acp request.
     *
     * @return  bool
     */
    public function isACPRequest()
    {
        return $this->isACPRequest;
    }

    /**
     * @deprecated 5.6 - This method always returns false.
     */
    public function inRescueMode()
    {
        return false;
    }
}
