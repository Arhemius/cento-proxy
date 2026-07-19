// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IBitmap} from "support/interfaces/IBitmap.sol";
import {bitmap256} from "cento/types/bitmap256.sol";

contract ReferenceBitmap is IBitmap {
    struct Bitmap {
        bool[256] slots;
    }

    function _unsafeToUint8(uint256 x) private pure returns (uint8 r) {
        assembly {
            r := x
        }
    }

    function _fromUint256(uint256 bitmap) private pure returns (Bitmap memory result) {
        for (uint16 i = 0; i < 256; i++) {
            result.slots[i] = (bitmap & (uint256(1) << i)) != 0;
        }
    }

    function _toUint256(Bitmap memory self) private pure returns (uint256 result) {
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) {
                result |= uint256(1) << i;
            }
        }
    }

    function popFirstFilledSlot(bitmap256 bitmap) external pure override returns (bitmap256 nextBitmap, uint8 index) {
        Bitmap memory self = _fromUint256(bitmap256.unwrap(bitmap));
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) {
                index = _unsafeToUint8(i);
                self.slots[i] = false;
                nextBitmap = bitmap256.wrap(_toUint256(self));
                return (nextBitmap, index);
            }
        }
        revert NoFreeSlots();
    }

    function getFirstEmptySlot(bitmap256 bitmap) external pure override returns (uint8 index) {
        Bitmap memory self = _fromUint256(bitmap256.unwrap(bitmap));
        for (uint16 i = 0; i < 256; i++) {
            if (!self.slots[i]) {
                return _unsafeToUint8(i);
            }
        }
        revert NoFreeSlots();
    }

    function countFilledSlots(bitmap256 bitmap) external pure override returns (uint16 count) {
        Bitmap memory self = _fromUint256(bitmap256.unwrap(bitmap));
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) count++;
        }
    }

    function isSlotOccupied(bitmap256 bitmap, uint8 index) external pure override returns (bool) {
        Bitmap memory self = _fromUint256(bitmap256.unwrap(bitmap));
        return self.slots[index];
    }

    function fillSlotAt(bitmap256 bitmap, uint8 index) external pure override returns (bitmap256 nextBitmap) {
        Bitmap memory self = _fromUint256(bitmap256.unwrap(bitmap));
        self.slots[index] = true;
        nextBitmap = bitmap256.wrap(_toUint256(self));
    }

    function clearSlotAt(bitmap256 bitmap, uint8 index) external pure override returns (bitmap256 nextBitmap) {
        Bitmap memory self = _fromUint256(bitmap256.unwrap(bitmap));
        self.slots[index] = false;
        nextBitmap = bitmap256.wrap(_toUint256(self));
    }
}