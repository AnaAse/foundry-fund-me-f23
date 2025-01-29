// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); //we can use this user when we want to work with somebody
    uint256 constant SEND_VALUE = 0.01 ether; // that makes it 100000000000000000
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x106379F11C3cF4027C38655b79327081eA9C9Cf5);   OJO este numero copiado del curso!!!
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);

        //What can we do to work with addresses outside our system?
        // 1. Unit
        //   -Testing a specific part of our code
        // 2. Integration
        //   -Testing how our code works with other parts of our code
        // 3. Forked
        //   -Testing our code on a simulated real environment
        // 4. Staging
        //   - Testing our code in a real environment that is not production
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertTrue(version == 4 || version == 6, "Version must be 4 or 6");
        // assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); //hey the next line should revert!!
        // assert (This tx fails/reverts)
        fundMe.fund{value: 0}(); //send with no value, 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next TX will be sent by USER... the following fundME.fund will be sent by USER
        console.log("FundMe contract balance before funding: ", address(fundMe).balance);
        fundMe.fund{value: SEND_VALUE}(); //vamos a enviar lo que hemos determinado arriba en una variable, mas que 5$
        console.log("FundMe contract balance after funding: ", address(fundMe).balance);

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
        console.log("User balance after funding: ", address(USER).balance);
    }
    // reset everything every simgle time as it will run SetUp and then the function, again SetUp and the other function

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }
    // any test we write after the above modifier, if we add the funded

    function testOnlyOwnerCanWithdraw() public funded {
        //this funded comes from the modifier to avoid repeating code
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        //Arrange . The test we are testing the withdraw at FundMe.sol.
        // Before we have to see whats our balance before so that we can compare our balances after
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        uint256 gasStart = gasleft(); //Lets say 1000, we had
        // vm.txGasPrice(GAS_PRICE); // min 12:19
        vm.prank(fundMe.getOwner()); //c: 200, we spend
        fundMe.withdraw();

        uint256 gasEnd = gasleft(); // 800 left
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10; //if you want to use number to generate addresses you must use uint160 instead of uint256
        uint160 startingFunderIndex = 1;
        //we create a loop
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // address (1) just dont use 0 address as often reverts
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        // Arrange
        uint160 numberOfFunders = 10; //if you want to use number to generate addresses you must use uint160 instead of uint256
        uint160 startingFunderIndex = 1;
        //we create a loop
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // address (1) just dont use 0 address as often reverts
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Debugging: Log balances before withdrawal
        //   console.log("Starting Owner Balance: ", startingOwnerBalance);
        //    console.log("Starting FundMe Balance: ", startingFundMeBalance);

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        // Debugging: Log balances after withdrawal
        console.log("Final Owner Balance: ", fundMe.getOwner().balance);
        console.log("Final FundMe Balance: ", address(fundMe).balance);

        // Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
    }
}
