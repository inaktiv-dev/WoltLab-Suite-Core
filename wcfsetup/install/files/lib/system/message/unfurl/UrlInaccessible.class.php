<?php

namespace wcf\system\message\unfurl;

use Exception;

/**
 * Denotes a permanent failing url, because the url is inaccessible.
 *
 * @author      Joshua Ruesweg
 * @copyright   2001-2021 WoltLab GmbH
 * @license     GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package     WoltLabSuite\Core\System\Message\Unfurl
 * @since       5.4
 */
class UrlInaccessible extends Exception
{
}
