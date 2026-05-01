// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";

/**
 * @title CountFilledSlots Tests
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256)
 * - Output: count (uint16)
 * - Behavior: Returns number of set bits
 */
contract CountFilledSlotsTest is LibBitmapAssert {
    
    function test_Count_EmptyBitmap_Returns0() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 0);
    }
    
    function test_Count_SingleBit_Returns1() public pure {
        uint256 bitmap = given_SingleBit(42);
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 1);
    }
    
    function test_Count_FullBitmap_Returns256() public pure {
        uint256 bitmap = given_FullBitmap();
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 256);
    }
    
    function test_Count_Range_ReturnsLength() public pure {
        uint256 bitmap = given_Range(10, 19); // 10 slots
        uint16 count = when_CountFilledSlots(bitmap);
        then_CountIs(count, 10);
    }
    
    function test_Oracle_Count_Various() public pure {
        uint8[] memory indices = new uint8[](5);
        indices[0] = 0;
        indices[1] = 64;
        indices[2] = 128;
        indices[3] = 192;
        indices[4] = 255;
        uint256 bitmap = given_MultipleBits(indices);
        uint16 count = when_CountFilledSlots(bitmap);
        then_MatchesOracle_CountFilledSlots(bitmap, count);
    }
    
    function testFuzz_Oracle_Count(uint256 bitmap) public pure {
        uint16 count = when_CountFilledSlots(bitmap);
        then_MatchesOracle_CountFilledSlots(bitmap, count);
    }
}