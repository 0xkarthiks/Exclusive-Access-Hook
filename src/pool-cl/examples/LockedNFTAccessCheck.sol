// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {IExclusiveAccessCheck} from "../ExclusiveAccessPoolHook.sol";

contract LockedNFTAccessCheck is IExclusiveAccessCheck {
    IERC721 public nftContract;
    mapping(address => uint256) public lockTimestamps;

    uint256 public lockDuration;

    constructor(address _nftContract, uint256 _lockDuration) {
        nftContract = IERC721(_nftContract);
        lockDuration = _lockDuration;
    }

    function lockNFT(uint256 tokenId) external {
        require(
            nftContract.ownerOf(tokenId) == msg.sender,
            "You don't own this NFT"
        );
        lockTimestamps[msg.sender] = block.timestamp + lockDuration;
        nftContract.transferFrom(msg.sender, address(this), tokenId);
    }

    function verify(address user) external view override returns (bool) {
        return
            block.timestamp >= lockTimestamps[user] &&
            lockTimestamps[user] != 0;
    }

    function unlockNFT(uint256 tokenId) external {
        require(lockTimestamps[msg.sender] != 0, "No locked NFT found");
        require(
            block.timestamp >= lockTimestamps[msg.sender],
            "Lock period not over"
        );
        lockTimestamps[msg.sender] = 0;
        nftContract.transferFrom(address(this), msg.sender, tokenId);
    }
}
