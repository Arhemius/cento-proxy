// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IBitmap} from "support/interfaces/IBitmap.sol";
import {bitmap256} from "cento/types/bitmap256.sol";

/**
 * @title LibBitmapAdapter
 * @notice Contract adapter that implements IBitmap by delegating to LibBitmap library
 * @dev Enables interface-based testing of the LibBitmap library
 */
contract LibBitmapAdapter is IBitmap {

    function popFirstFilledSlot(bitmap256 bitmap) external pure override returns (bitmap256 nextBitmap, uint8 index) {
        return bitmap.popFirstFilledSlot();
    }

    function getFirstEmptySlot(bitmap256 bitmap) external pure override returns (uint8 index) {
        return bitmap.getFirstEmptySlot();
    }

    function countFilledSlots(bitmap256 bitmap) external pure override returns (uint16 count) {
        return bitmap.countFilledSlots();
    }

    function isSlotOccupied(bitmap256 bitmap, uint8 index) external pure override returns (bool occupied) {
        return bitmap.isSlotOccupied(index);
    }

    function fillSlotAt(bitmap256 bitmap, uint8 index) external pure override returns (bitmap256 nextBitmap) {
        return bitmap.fillSlotAt(index);
    }

    function clearSlotAt(bitmap256 bitmap, uint8 index) external pure override returns (bitmap256 nextBitmap) {
        return bitmap.clearSlotAt(index);
    }
}