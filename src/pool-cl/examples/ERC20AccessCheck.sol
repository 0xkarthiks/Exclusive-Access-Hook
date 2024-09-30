// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IExclusiveAccessCheck} from "../ExclusiveAccessPoolHook.sol";

contract ERC20AccessCheck is IExclusiveAccessCheck {
    IERC20 public token;
    uint256 public minBalance;

    constructor(address _token, uint256 _minBalance) {
        token = IERC20(_token);
        minBalance = _minBalance;
    }

    function verify(address user) external view override returns (bool) {
        return token.balanceOf(user) >= minBalance;
    }
}
