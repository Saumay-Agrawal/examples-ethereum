// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded) private s_registry;
    address private immutable i_owner;
    AggregatorV3Interface private immutable s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "didn't send enough ETH");
        s_funders.push(msg.sender);
        s_registry[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 i=0; i < s_funders.length; i++) {
            s_registry[s_funders[i]] = 0;
        }
        s_funders = new address[](0);
        payable(msg.sender).transfer(address(this).balance);
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for(uint256 i=0; i < fundersLength; i++) {
            s_registry[s_funders[i]] = 0;
        }
        s_funders = new address[](0);
        payable(msg.sender).transfer(address(this).balance);

    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "must be owner");
        if (msg.sender != i_owner) { revert NotOwner(); }
        _;
    }

    /**
     * View / pure functions (getters)
     */

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_registry[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
    

    

}