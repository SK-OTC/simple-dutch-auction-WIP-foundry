// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console2, StdStyle} from "forge-std/Test.sol";
import {DutchAuction} from "../src/DutchAuction.sol";
contract DutchAuctionTest is Test {
    DutchAuction public auction;
    address public seller;
    address public buyer1;
    address public buyer2;
    uint256 public itemId = 1;
    uint256 public startPrice = 10 ether;
    uint256 public reservePrice = 2 ether;


    function setUp() public {
        seller = payable(address(0x1));
        buyer1 = payable(address(0x2));
        buyer2 = payable(address(0x3));
        vm.prank(seller);
        auction = new DutchAuction(itemId, startPrice, reservePrice, 1 ether, 1 minutes, 10 minutes);
        vm.deal(address(auction), 5 ether);
    }
    
    // 1. Test Auction Initialization
    function testAuctionInitialization() public {
        assertEq(auction.seller(), seller);
        assertEq(auction.itemId(), itemId);
        assertEq(auction.startPrice(), startPrice);
        assertEq(auction.reservePrice(), reservePrice);
    }   

    function testGetPriceAtStart() public {
        

    }

      // 5. Test Edge Cases
        // Multiple buyers attempting simultaneously
        // Price reaching reserve
    

}

  