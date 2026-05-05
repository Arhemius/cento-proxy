// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapAssert} from "./AAA/Assert.sol";
import {LibBitmapTestSetup} from "./AAA/Setup.sol";

/**
 * @title IsSlotOccupied Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (uint256), index (uint8)
 * - Output: occupied (bool)
 * - Behavior: Returns true if bit at index is set
 */
contract IsSlotOccupiedTest is LibBitmapAssert {
    constructor() LibBitmapAssert(new LibBitmapTestSetup()) {}

    function test_Occupied_EmptyBitmap_ReturnsFalse() public view {
        uint256 bitmap = given_EmptyBitmap();
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, false);
    }

    function test_Occupied_FullBitmap_ReturnsTrue() public view {
        uint256 bitmap = given_FullBitmap();
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, true);
    }

    function test_Occupied_SingleBit_TrueForThatIndex() public view {
        uint256 bitmap = given_SingleBit(42);
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, true);
    }

    function test_Occupied_SingleBit_FalseForOtherIndex() public view {
        uint256 bitmap = given_SingleBit(42);
        bool occupied = when_IsSlotOccupied(bitmap, 43);
        then_IsOccupied(occupied, false);
    }

    function test_Occupied_BoundaryIndices() public view {
        uint256 bitmap = given_SingleBit(0);
        bool occupied = when_IsSlotOccupied(bitmap, 0);
        then_IsOccupied(occupied, true);
        occupied = when_IsSlotOccupied(bitmap, 1);
        then_IsOccupied(occupied, false);

        bitmap = given_SingleBit(255);
        occupied = when_IsSlotOccupied(bitmap, 255);
        then_IsOccupied(occupied, true);
        occupied = when_IsSlotOccupied(bitmap, 254);
        then_IsOccupied(occupied, false);
    }

    // === Interface Compliance (Fuzz Tests) ===

    function testFuzz_IsSlotOccupied_Complies(uint256 bitmap, uint8 index) public view {
        then_CompliesWith_IsSlotOccupied(bitmap, index);
    }
}