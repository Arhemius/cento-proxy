// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {bitmap256} from "cento/types/bitmap256.sol";

interface IBitmap {
    error NoFreeSlots();

    function popFirstFilledSlot(bitmap256 bitmap) external pure returns (bitmap256 nextBitmap, uint8 index);

    function getFirstEmptySlot(bitmap256 bitmap) external pure returns (uint8 index);

    function countFilledSlots(bitmap256 bitmap) external pure returns (uint16 count);

    function isSlotOccupied(bitmap256 bitmap, uint8 index) external pure returns (bool occupied);

    function fillSlotAt(bitmap256 bitmap, uint8 index) external pure returns (bitmap256 nextBitmap);

    function clearSlotAt(bitmap256 bitmap, uint8 index) external pure returns (bitmap256 nextBitmap);
}