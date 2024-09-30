// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IExclusiveAccessCheck} from "../ExclusiveAccessPoolHook.sol";

contract WhitelistAccessCheck is IExclusiveAccessCheck {
    mapping(address => bool) public whitelist;

    constructor(address[] memory initialWhitelist) {
        for (uint256 i = 0; i < initialWhitelist.length; i++) {
            whitelist[initialWhitelist[i]] = true;
        }
    }

    function addToWhitelist(address user) external {
        whitelist[user] = true;
    }

    function removeFromWhitelist(address user) external {
        whitelist[user] = false;
    }

    function verify(address user) external view override returns (bool) {
        return whitelist[user];
    }
}
