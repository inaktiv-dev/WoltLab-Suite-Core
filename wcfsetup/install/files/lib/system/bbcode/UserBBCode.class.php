<?php

namespace wcf\system\bbcode;

use wcf\data\user\UserProfile;
use wcf\system\message\embedded\object\MessageEmbeddedObjectManager;
use wcf\system\WCF;

/**
 * Parses the [user] bbcode tag.
 *
 * @author      Alexander Ebert
 * @copyright   2001-2019 WoltLab GmbH
 * @license     GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @since       3.0
 */
final class UserBBCode extends AbstractBBCode
{
    /**
     * @inheritDoc
     */
    public function getParsedTag(array $openingTag, $content, array $closingTag, BBCodeParser $parser): string
    {
        $userID = (!empty($openingTag['attributes'][0])) ? \intval($openingTag['attributes'][0]) : 0;
        if (!$userID) {
            return "[user]{$content}[/user]";
        }

        /** @var UserProfile $userProfile */
        $userProfile = MessageEmbeddedObjectManager::getInstance()->getObject('com.woltlab.wcf.user', $userID);

        return WCF::getTPL()->fetch('userBBCodeTag', 'wcf', [
            'username' => $content,
            'userProfile' => $userProfile,
        ], true);
    }
}
