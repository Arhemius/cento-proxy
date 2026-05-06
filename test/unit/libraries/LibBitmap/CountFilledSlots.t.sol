// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import "../../../_support/etl/_ETL.sol";

/**
 * @title CountFilledSlots Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (uint256)
 * - Output: count (uint16)
 * - Behavior: Returns number of set bits
 */
contract CountFilledSlotsTest is LibBitmapAssert, Ops {
    using T for bytes;
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}

    function test_Count_EmptyBitmap_Returns0() public view {
        uint256 bitmap = given_EmptyBitmap();
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 0);
    }

    function test_Count_SingleBit_Returns1() public view {
        uint256 bitmap = given_SingleBit(42);
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 1);
    }

    function test_Count_FullBitmap_Returns256() public view {
        uint256 bitmap = given_FullBitmap();
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 256);
    }

    function test_Count_Range_ReturnsLength() public view {
        uint256 bitmap = given_Range(10, 19); // 10 slots
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 10);
    }

    function test_Count_VariousBits() public view {
        uint8[] memory indices = abi.encode(0, 64, 128, 192, 255).u8();
        uint256 bitmap = given_MultipleBits(indices);
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 5);
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_Count_Complies(uint256 bitmap) public view {
        then_CompliesWith_CountFilledSlots(bitmap);
    }
}