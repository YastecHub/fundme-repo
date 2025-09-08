// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
//ToDo:
//Get Funds from Users
//Withdraw the funds
//Set a minimum value in USD
contract FundMe{
   using PriceConverter for uint256;

   uint256 public minimumUsd = 5e18;

   address[] public funders;
   mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

   address public owner;

   constructor() {
    owner = msg.sender;
   }

    function fund() public payable {
        //Allow Users to send $
        //Have a minimum $ to sent
        require(msg.value.getConversionRate() >= minimumUsd, "did send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner{
        for (uint256 funderIndex = 0; funderIndex < funders.length ; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);

        //actually withdraw the funds(3-methods)
        //Transfer
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        //Call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be the owner , BARAU NIEE!!");
        _;
    }
}