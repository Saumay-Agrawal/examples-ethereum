// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public registry;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");
        funders.push(msg.sender);
        registry[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 i=0; i < funders.length; i++) {
            registry[funders[i]] = 0;
        }
        funders = new address[](0);
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "must be owner");
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    

}