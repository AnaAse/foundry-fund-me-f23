// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";


contract InteractionsTest is Test {
    FundMe fundMe;
    
    address USER = makeAddr("user"); //we can use this user when we want to work with somebody
    uint256 constant SEND_VALUE = 0.1 ether; // that makes it 100000000000000000
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, 100e18);  
    }

    function testUserCanFundInteractions() public {
        console.log("FundMe contract balance before funding: ", address(fundMe).balance);
        
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe (address(fundMe));

        console.log("FundMe contract balance after funding: ", address(fundMe).balance);
        console.log("User balance after funding: ", address(USER).balance);
        //vm.prank(USER);
        //fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address (fundMe));

        assert(address(fundMe).balance == 0);
    }
}