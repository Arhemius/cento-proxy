// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IBitmap} from "support/interfaces/IBitmap.sol";
import {LibBitmapDebug} from "support/oracles/ReferenceBitmapDebug.sol";

/**
 * @title LibBitmapAdapter
 * @notice Contract adapter that implements IBitmap by delegating to LibBitmap library
 * @dev Enables interface-based testing of the LibBitmap library
 */
contract LibBitmapDebugAdapter is IBitmap {
    using LibBitmapDebug for uint256;

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