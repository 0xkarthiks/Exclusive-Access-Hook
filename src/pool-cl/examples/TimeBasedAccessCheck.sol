// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IExclusiveAccessCheck} from "../ExclusiveAccessPoolHook.sol";

contract TimeBasedAccessCheck is IExclusiveAccessCheck {
    uint256 public unlockTimestamp;

    constructor(uint256 _unlockTimestamp) {
        unlockTimestamp = _unlockTimestamp;
    }

    function verify(address) external view override returns (bool) {
        return block.timestamp >= unlockTimestamp;
    }
}
