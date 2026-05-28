// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {IBitmap} from "support/interfaces/IBitmap.sol";

/**
 * @title ReferenceBitmap
 * @notice Array-based reference implementation (OBVIOUSLY CORRECT)
 * @dev Contract implementing IBitmap with obviously-correct algorithms
 */
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

    function popFirstFilledSlot(uint256 bitmap) external pure override returns (uint256 nextBitmap, uint8 index) {
        Bitmap memory self = _fromUint256(bitmap);
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) {
                index = _unsafeToUint8(i);
                self.slots[i] = false;
                nextBitmap = _toUint256(self);
                return (nextBitmap, index);
            }
        }
        revert NoFreeSlots();
    }

    function getFirstEmptySlot(uint256 bitmap) external pure override returns (uint8 index) {
        Bitmap memory self = _fromUint256(bitmap);
        for (uint16 i = 0; i < 256; i++) {
            if (!self.slots[i]) {
                return _unsafeToUint8(i);
            }
        }
        revert NoFreeSlots();
    }

    function countFilledSlots(uint256 bitmap) external pure override returns (uint16 count) {
        Bitmap memory self = _fromUint256(bitmap);
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) count++;
        }
    }

    function isSlotOccupied(uint256 bitmap, uint8 index) external pure override returns (bool) {
        Bitmap memory self = _fromUint256(bitmap);
        return self.slots[index];
    }

    function fillSlotAt(uint256 bitmap, uint8 index) external pure override returns (uint256 nextBitmap) {
        Bitmap memory self = _fromUint256(bitmap);
        self.slots[index] = true;
        nextBitmap = _toUint256(self);
    }

    function clearSlotAt(uint256 bitmap, uint8 index) external pure override returns (uint256 nextBitmap) {
        Bitmap memory self = _fromUint256(bitmap);
        self.slots[index] = false;
        nextBitmap = _toUint256(self);
    }
}