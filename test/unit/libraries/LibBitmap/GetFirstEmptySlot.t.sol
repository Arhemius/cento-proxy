// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";

/**
 * @title GetFirstEmptySlot Tests
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256)
 * - Output: index (uint8)
 * - Behavior: Returns index of lowest empty slot
 * - Reverts: NoFreeSlots if bitmap is full
 */
contract GetFirstEmptySlotTest is LibBitmapAssert {
    
    // === Input: Empty Bitmap ===
    
    function test_Empty_EmptyBitmap_Returns0() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 0);
    }
    
    // === Input: Partially Filled ===
    
    function test_Empty_OnlySlot0Filled_Returns1() public pure {
        uint256 bitmap = given_SingleBit(0);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 1);
    }
    
    function test_Empty_Range0to63Filled_Returns64() public pure {
        uint256 bitmap = given_Range(0, 63);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 64);
    }
    
    function test_Empty_Range0to127Filled_Returns128() public pure {
        uint256 bitmap = given_Range(0, 127);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 128);
    }
    
    function test_Empty_Range0to191Filled_Returns192() public pure {
        uint256 bitmap = given_Range(0, 191);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 192);
    }
    
    function test_Empty_AllExceptLast_Returns255() public pure {
        uint256 bitmap = given_AllExcept(255);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_IndexIs(idx, 255);
    }
    
    // === Error: Full Bitmap ===

    function test_Empty_FullBitmap_Reverts() public {
        uint256 bitmap = given_FullBitmap();
        then_RevertsWithNoFreeSlots();
        this.when_GetFirstEmptySlot_External(bitmap);
    }

    function test_Oracle_Empty_FullBitmap_Reverts() public {
        uint256 bitmap = given_FullBitmap();
        then_RevertsWithNoFreeSlots();
        this.when_Oracle_GetFirstEmptySlot_External(bitmap);
    }
    
    // === Oracle Verification ===
    
    function test_Oracle_Empty_EmptyBitmap() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_MatchesOracle_GetFirstEmptySlot(bitmap, idx);
    }
    
    function test_Oracle_Empty_Range() public pure {
        uint256 bitmap = given_Range(0, 100);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_MatchesOracle_GetFirstEmptySlot(bitmap, idx);
    }
    
    function testFuzz_Oracle_Empty(uint256 bitmap) public pure {
        vm.assume(bitmap != FULL);
        uint8 idx = when_GetFirstEmptySlot(bitmap);
        then_MatchesOracle_GetFirstEmptySlot(bitmap, idx);
    }
}