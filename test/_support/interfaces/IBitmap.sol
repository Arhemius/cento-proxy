// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {bitmap256} from "src/libraries/LibBitmap.sol";

/**
 * @title IBitmap
 * @notice Interface for bitmap operations
 * @dev Defines the operational contract for bitmap implementations
 */
interface IBitmap {
    error NoFreeSlots();

    /**
     * @notice Returns the index of the lowest set bit and clears it
     * @param bitmap The bitmap to operate on
     * @return nextBitmap The bitmap with the lowest set bit cleared
     * @return index The index of the cleared bit
     */
    function popFirstFilledSlot(bitmap256 bitmap) external pure returns (bitmap256 nextBitmap, uint8 index);

    /**
     * @notice Returns the index of the lowest empty bit
     * @param bitmap The bitmap to operate on
     * @return index The index of the lowest empty bit
     */
    function getFirstEmptySlot(bitmap256 bitmap) external pure returns (uint8 index);

    /**
     * @notice Counts the number of set bits in the bitmap
     * @param bitmap The bitmap to operate on
     * @return count The number of set bits
     */
    function countFilledSlots(bitmap256 bitmap) external pure returns (uint16 count);

    /**
     * @notice Checks if a specific bit is set
     * @param bitmap The bitmap to check
     * @param index The bit index to check
     * @return occupied True if the bit is set
     */
    function isSlotOccupied(bitmap256 bitmap, uint8 index) external pure returns (bool occupied);

    /**
     * @notice Sets a specific bit
     * @param bitmap The bitmap to operate on
     * @param index The bit index to set
     * @return nextBitmap The bitmap with the bit set
     */
    function fillSlotAt(bitmap256 bitmap, uint8 index) external pure returns (bitmap256 nextBitmap);

    /**
     * @notice Clears a specific bit
     * @param bitmap The bitmap to operate on
     * @param index The bit index to clear
     * @return nextBitmap The bitmap with the bit cleared
     */
    function clearSlotAt(bitmap256 bitmap, uint8 index) external pure returns (bitmap256 nextBitmap);
}