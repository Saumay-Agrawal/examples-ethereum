// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interaction.s.sol";

contract FundMeTestIntegration is Test {

    uint256 number = 1;
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);

    }

    function testUserCanFund() public {
        FundFundMe fund = new FundFundMe();
        fund.fundFundMe(address(fundMe));
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertTrue(amountFunded == SEND_VALUE, "Amount funded should be 0.5");
    }

}