// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/**
 * @title ReferenceBitmap
 * @notice Array-based reference implementation (OBVIOUSLY CORRECT)
 */
library ReferenceBitmap {
    error NoFreeSlots();
    
    struct Bitmap {
        bool[256] slots;
    }

    function _unsafeToUint8(uint256 x) private pure returns (uint8 r) {
        assembly {
            r := x
        }
    }
    
    function popFirstFilledSlot(Bitmap memory self) internal pure returns (Bitmap memory nextBitmap, uint8 index) {
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) {
                index = _unsafeToUint8(i);
                nextBitmap = self;
                nextBitmap.slots[i] = false;
                return (nextBitmap, index);
            }
        }
        revert("No filled slots");
    }
    
    function getFirstEmptySlot(Bitmap memory self) internal pure returns (uint8 index) {
        for (uint16 i = 0; i < 256; i++) {
            if (!self.slots[i]) {
                return _unsafeToUint8(i);
            }
        }
        revert NoFreeSlots();
    }
    
    function countFilledSlots(Bitmap memory self) internal pure returns (uint16 count) {
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) count++;
        }
    }
    
    function isSlotOccupied(Bitmap memory self, uint8 index) internal pure returns (bool) {
        return self.slots[index];
    }
    
    function fillSlotAt(Bitmap memory self, uint8 index) internal pure returns (Bitmap memory) {
        self.slots[index] = true;
        return self;
    }
    
    function clearSlotAt(Bitmap memory self, uint8 index) internal pure returns (Bitmap memory) {
        self.slots[index] = false;
        return self;
    }
    
    // Conversion helpers
    function fromUint256(uint256 bitmap) internal pure returns (Bitmap memory result) {
        for (uint16 i = 0; i < 256; i++) {
            result.slots[i] = (bitmap & (uint256(1) << i)) != 0;
        }
    }
    
    function toUint256(Bitmap memory self) internal pure returns (uint256 result) {
        for (uint16 i = 0; i < 256; i++) {
            if (self.slots[i]) {
                result |= (uint256(1) << i);
            }
        }
    }
}