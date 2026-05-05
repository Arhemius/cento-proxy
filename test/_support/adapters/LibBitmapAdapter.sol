// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IBitmap} from "../interfaces/IBitmap.sol";
import {LibBitmap} from "../../../src/libraries/LibBitmap.sol";

/**
 * @title LibBitmapAdapter
 * @notice Contract adapter that implements IBitmap by delegating to LibBitmap library
 * @dev Enables interface-based testing of the LibBitmap library
 */
contract LibBitmapAdapter is IBitmap {
    using LibBitmap for uint256;

    function popFirstFilledSlot(uint256 bitmap) external pure override returns (uint256 nextBitmap, uint8 index) {
        return bitmap.popFirstFilledSlot();
    }

    function getFirstEmptySlot(uint256 bitmap) external pure override returns (uint8 index) {
        return bitmap.getFirstEmptySlot();
    }

    function countFilledSlots(uint256 bitmap) external pure override returns (uint16 count) {
        return bitmap.countFilledSlots();
    }

    function isSlotOccupied(uint256 bitmap, uint8 index) external pure override returns (bool occupied) {
        return bitmap.isSlotOccupied(index);
    }

    function fillSlotAt(uint256 bitmap, uint8 index) external pure override returns (uint256 nextBitmap) {
        return bitmap.fillSlotAt(index);
    }

    function clearSlotAt(uint256 bitmap, uint8 index) external pure override returns (uint256 nextBitmap) {
        return bitmap.clearSlotAt(index);
    }
}