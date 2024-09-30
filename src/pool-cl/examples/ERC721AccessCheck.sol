// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IExclusiveAccessCheck} from "../ExclusiveAccessPoolHook.sol";

contract ERC721AccessCheck is IExclusiveAccessCheck {
    IERC721 public nftContract;

    constructor(address _nftContract) {
        nftContract = IERC721(_nftContract);
    }

    function verify(address user) external view override returns (bool) {
        return nftContract.balanceOf(user) > 0; // User must hold at least one NFT
    }
}
