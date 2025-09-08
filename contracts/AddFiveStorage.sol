// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage{
    //add 5
    //override
    // virtual override
    function store(uint256 _newNumber) public override{
        favNo = _newNumber + 5;
    }
} 