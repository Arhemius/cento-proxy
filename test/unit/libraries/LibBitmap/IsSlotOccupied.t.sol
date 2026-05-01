// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;


import {LibBitmapAssert} from "./AAA/Assert.sol";

/**
 * @title IsSlotOccupied Tests
 * 
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: occupied (bool)
 * - Behavior: Returns true if bit at index is set
 */
contract IsSlotOccupiedTest is LibBitmapAssert {
    
    function test_Occupied_EmptyBitmap_ReturnsFalse() public pure {
        uint256 bitmap = given_EmptyBitmap();
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, false);
    }
    
    function test_Occupied_FullBitmap_ReturnsTrue() public pure {
        uint256 bitmap = given_FullBitmap();
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, true);
    }
    
    function test_Occupied_SingleBit_TrueForThatIndex() public pure {
        uint256 bitmap = given_SingleBit(42);
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, true);
    }
    
    function test_Occupied_SingleBit_FalseForOtherIndex() public pure {
        uint256 bitmap = given_SingleBit(42);
        bool occupied = when_IsSlotOccupied(bitmap, 43);
        then_IsOccupied(occupied, false);
    }
    
    function testFuzz_Oracle_Occupied(uint256 bitmap, uint8 index) public pure {
        bool occupied = when_IsSlotOccupied(bitmap, index);
        then_MatchesOracle_IsSlotOccupied(bitmap, index, occupied);
    }
}