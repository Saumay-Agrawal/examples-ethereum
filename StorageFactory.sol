// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { SimpleStorage } from "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public simpleStorageContracts;

    function createSimpleStorageContract() public {
        simpleStorageContracts.push(new SimpleStorage());
    }

    function sfStore(uint _simpleStorageIndex, uint _newSimpleStorageNumber) public {
        SimpleStorage mycontract = simpleStorageContracts[_simpleStorageIndex];
        mycontract.store(_newSimpleStorageNumber);
    }

    function sfGet(uint _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage mycontract = simpleStorageContracts[_simpleStorageIndex];
        return mycontract.retrieve();
    }

}