// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//ToDo:
//Get Funds from Users
//Withdraw the funds
//Set a minimum value in USD
contract FundMe{

   uint256 public minimumUsd = 5e18;
   address[] public funders;
   mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        //Allow Users to send $
        //Have a minimum $ to sent
        require(getConversionRate(msg.value) >= minimumUsd, "did send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function getPrice() public view returns(uint256){
        //Address
        //ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xdC08BeB25e27168F34Db5AE04387e9F81E207356);
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0xdC08BeB25e27168F34Db5AE04387e9F81E207356).version();
    }
}