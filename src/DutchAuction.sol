// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract DutchAuction {
    //   An auction where the price starts high and decreases over time.
    address public seller;
    address public buyer;
    uint256 public itemId;
    uint256 public startPrice;
    uint256 public reservePrice;
    uint256 public priceDecrement;
    uint256 public auctionStartTime;
    uint256 public auctionEndTime;
    uint256 public decrementInterval;
    bool public isSold;

}

