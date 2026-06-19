// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibBitmapTestSetup} from "./AAA/Setup.sol";
import {bitmap256} from "src/libraries/LibBitmap.sol";

/**
 * @title IsSlotOccupied Tests
 *
 * FUNCTION SPEC:
 * - Input: bitmap (bitmap256), index (uint8)
 * - Output: occupied (bool)
 * - Behavior: Returns true if bit at index is set
 */
contract IsSlotOccupiedTest is LibBitmapTestSetup {

    function test_Occupied_EmptyBitmap_False() public view {
        bitmap256 bitmap = given_EmptyBitmap();
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, false);
    }

    function test_Occupied_FullBitmap_True() public view {
        bitmap256 bitmap = given_FullBitmap();
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, true);
    }

    function test_Occupied_SingleBit_TrueForThatIndex() public view {
        bitmap256 bitmap = given_SingleBit(42);
        bool occupied = when_IsSlotOccupied(bitmap, 42);
        then_IsOccupied(occupied, true);
    }

    function test_Occupied_SingleBit_FalseForOtherIndex() public view {
        bitmap256 bitmap = given_SingleBit(42);
        bool occupied = when_IsSlotOccupied(bitmap, 43);
        then_IsOccupied(occupied, false);
    }

    function test_Occupied_BoundaryIndices() public view {
        bitmap256 bitmap = given_SingleBit(0);
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

    function testFuzz_Occupied_Complies(bitmap256 bitmap, uint8 index) public view {
        then_CompliesWith_IsSlotOccupied(bitmap, index);
    }
}