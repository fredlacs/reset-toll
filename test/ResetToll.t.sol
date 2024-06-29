// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ResetToll} from "../src/ResetToll.sol";

contract ResetTollTest is Test {
    ResetToll public resetToll;

    function setUp() public {
        resetToll = new ResetToll(address(5));
    }

    function test_SetsFee() public {
        resetToll.setFee(address(1), 5);
        assertEq(resetToll.fee(address(1)), 5);
    }
}
