<?php

namespace wcf\data\user\rank;

use wcf\data\DatabaseObjectEditor;
use wcf\data\IEditableCachedObject;
use wcf\system\user\storage\UserStorageHandler;

/**
 * Provides functions to edit user ranks.
 *
 * @author  Marcel Werk
 * @copyright   2001-2019 WoltLab GmbH
 * @license GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 *
 * @method static UserRank    create(array $parameters = [])
 * @method      UserRank    getDecoratedObject()
 * @mixin       UserRank
 */
class UserRankEditor extends DatabaseObjectEditor implements IEditableCachedObject
{
    /**
     * @inheritDoc
     */
    protected static $baseClass = UserRank::class;

    /**
     * @inheritDoc
     */
    public static function resetCache()
    {
        UserStorageHandler::getInstance()->resetAll('userRank');
    }
}
