// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
contract DutchAuction {
    //   An auction where the price starts high and decreases over time.
    event PurchaseItem(address indexed buyer, uint256 amountPaid, uint256 itemId);
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

    modifier onlyBeforeEnd() {
        require(block.timestamp <= auctionEndTime, "Auction has ended");
        _;
    }

    modifier onlyAfterStart() {
        require(block.timestamp >= auctionStartTime, "Auction has not started yet");
        _;
    }

    modifier onlyNotSold() {
        require(isSold == false, "Item has already been sold");
        _;
    }

    constructor(uint256 _itemId, uint256 _startPrice, uint256 _reservePrice, uint256 _priceDecrement, uint256 _decrementInterval, uint256 _auctionDuration) {
        seller = msg.sender;
        itemId = _itemId;
        startPrice = _startPrice;
        reservePrice = _reservePrice;
        priceDecrement = _priceDecrement;
        decrementInterval = _decrementInterval;
        auctionStartTime = block.timestamp;
        auctionEndTime = auctionStartTime + _auctionDuration;
        isSold = false;
    }


    function getPrice() public view onlyBeforeEnd onlyAfterStart onlyNotSold returns (int256) {
        // Calculate current price based on time elapsed using linear decay formula: 
        // startingPrice - (discountRate * timeElapsed)
        require(itemId != 0, "Item does not exist"); 

        uint256 timeElapsed = block.timestamp - auctionStartTime;
        uint256 intervalsPassed = timeElapsed / decrementInterval;
        uint256 currentDiscount = intervalsPassed * priceDecrement;
        
        if (currentDiscount >= uint256(startPrice)) {
                return int256(reservePrice); 
        }
        uint256 currentPrice = uint256(startPrice) - uint256(currentDiscount);

        if (currentPrice < uint256(reservePrice)) {
            return int256(reservePrice);
        }        
        return int256(currentPrice);
    }

    function buy() public payable onlyBeforeEnd onlyAfterStart onlyNotSold {
        require(itemId != 0, "Item does not exist");
        int256 currentPrice = getPrice();
        require(msg.value >= uint256(currentPrice), "Insufficient funds to buy the item");
        isSold = true;
        buyer = msg.sender;
        emit PurchaseItem(buyer, msg.value, itemId);
        
        (bool success,) = payable(seller).call{value: msg.value}(new bytes(0));
        require(success, "tx failed");
    }

}

