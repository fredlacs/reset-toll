// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SaturatingSend} from "../src/SaturatingSend.sol";

contract SaturatingSendTest is Test {
    SaturatingSend public saturatingSend;

    function setUp() public {
        saturatingSend = new SaturatingSend();
    }

    function test_Increment() public {
        // saturatingSend.increment();
        // assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        // counter.setNumber(x);
        // assertEq(counter.number(), x);
    }
}
