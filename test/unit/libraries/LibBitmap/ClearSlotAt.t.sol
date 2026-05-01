// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";

/**
 * @title ClearSlotAt Tests
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: nextBitmap (uint256)
 * - Behavior: Clears bit at index
 * - Idempotent: Clearing already-empty slot is no-op
 */
contract ClearSlotAtTest is LibBitmapAssert {
    
    function test_Clear_FullBitmap_ClearsBit() public pure {
        uint256 bitmap = given_FullBitmap();
        uint256 next = when_ClearSlotAt(bitmap, 42);
        then_SlotEmpty(next, 42);
    }
    
    function test_Clear_Idempotent() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint256 next = when_ClearSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }
    
    function test_Clear_PreservesOtherBits() public pure {
        uint8[] memory indices = new uint8[](2);
        indices[0] = 10;
        indices[1] = 20;
        uint256 bitmap = given_MultipleBits(indices);
        uint256 next = when_ClearSlotAt(bitmap, 10);
        then_SlotEmpty(next, 10);
        then_SlotOccupied(next, 20);
    }
    
    function test_Clear_AllIndices() public pure {
        uint256 bitmap = given_FullBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_ClearSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapEmpty(bitmap);
    }
    
    function testFuzz_Oracle_Clear(uint256 bitmap, uint8 index) public pure {
        uint256 next = when_ClearSlotAt(bitmap, index);
        then_MatchesOracle_ClearSlotAt(bitmap, index, next);
    }
}