// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";

/**
 * @title FillSlotAt Tests
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: nextBitmap (uint256)
 * - Behavior: Sets bit at index
 * - Idempotent: Filling already-filled slot is no-op
 */
contract FillSlotAtTest is LibBitmapAssert {
    
    function test_Fill_EmptyBitmap_SetsBit() public pure {
        uint256 bitmap = given_EmptyBitmap();
        uint256 next = when_FillSlotAt(bitmap, 42);
        then_SlotOccupied(next, 42);
    }
    
    function test_Fill_Idempotent() public pure {
        uint256 bitmap = given_SingleBit(42);
        uint256 next = when_FillSlotAt(bitmap, 42);
        then_BitmapIs(next, bitmap);
    }
    
    function test_Fill_PreservesOtherBits() public pure {
        uint256 bitmap = given_SingleBit(10);
        uint256 next = when_FillSlotAt(bitmap, 20);
        then_SlotOccupied(next, 10);
        then_SlotOccupied(next, 20);
    }
    
    function test_Fill_AllIndices() public pure {
        uint256 bitmap = given_EmptyBitmap();
        for (uint16 i = 0; i < 256; i++) {
            bitmap = when_FillSlotAt(bitmap, _unsafeToUint8(i));
        }
        then_BitmapFull(bitmap);
    }
    
    function testFuzz_Oracle_Fill(uint256 bitmap, uint8 index) public pure {
        uint256 next = when_FillSlotAt(bitmap, index);
        then_MatchesOracle_FillSlotAt(bitmap, index, next);
    }
}