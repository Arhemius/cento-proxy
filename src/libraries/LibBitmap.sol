// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./LibDebug.sol";

library LibBitmap {
    
    uint64 private constant DEBRUIJN64_MAGIC = 0x03f79d71b4cb0a89;
    bytes32 private constant DEBRUIJN64_TABLE_0 = 0x050c12181e21272d162b3335243b373e04111d262a323a3d031c313902300100;
    bytes32 private constant DEBRUIJN64_TABLE_1 = 0x0607080d09130e190a1f14220f281a2e0b17202c153423361025293c1b382f3f;

    error NoFreeSlots();

    function _unsafeToUint64(uint256 x) private pure returns (uint64 r) {
        assembly {
            r := x
        }
    }

    modifier onlySingleBit(uint256 x) {
        if (Debug.ON) assert((x != 0) && (x & (x - 1)) == 0);
        _;
    }

    function _ctz64(uint64 x) private pure returns (uint8 r) {
        unchecked {
            uint64 prod = x * DEBRUIJN64_MAGIC;
            uint256 idx = uint256(prod >> 58);
            bytes32 word = idx < 32 ? DEBRUIJN64_TABLE_0 : DEBRUIJN64_TABLE_1;
            assembly {
                let pos := sub(31, and(idx, 31))
                r := byte(pos, word)
            }
        }
    }

    function _lsbIndex(uint256 lsb) private pure onlySingleBit(lsb) returns (uint8) {
        unchecked {
            uint64 max64 = type(uint64).max;
            if ((lsb & max64) != 0)          return _ctz64(_unsafeToUint64(lsb));
            if (((lsb >> 64) & max64) != 0)  return _ctz64(_unsafeToUint64(lsb >> 64)) + 64;
            if (((lsb >> 128) & max64) != 0) return _ctz64(_unsafeToUint64(lsb >> 128)) + 128;
                                             return _ctz64(_unsafeToUint64(lsb >> 192)) + 192;
        }
    }

    function popFirstFilledSlot(uint256 bitmap) internal pure returns (uint256 nextBitmap, uint8 index) {
        if (bitmap == 0) revert NoFreeSlots();
        uint256 lsb;
        unchecked {
            lsb = bitmap & (~bitmap + 1);
        } 
        index = _lsbIndex(lsb);
        nextBitmap = bitmap ^ lsb;
    }

    function getFirstEmptySlot(uint256 bitmap) internal pure returns (uint8 index) {
        uint256 free;
        unchecked {
            free = ~bitmap & (bitmap + 1);
        }
        if (free == 0) revert NoFreeSlots();
        index = _lsbIndex(free);
    }

    function countFilledSlots(uint256 bitmap) internal pure returns (uint16 count) {
        for (; bitmap != 0; bitmap &= (bitmap - 1)) { 
            unchecked { count++; } 
        }
    }

    function _mask(uint8 index) private pure returns (uint256) {
        return uint256(1) << index;
    }
    
    function isSlotOccupied(uint256 bitmap, uint8 index) internal pure returns (bool) {
        return (bitmap & _mask(index)) != 0;
    }

    function fillSlotAt(uint256 bitmap, uint8 index) internal pure returns (uint256) {
        return bitmap | _mask(index);
    }

    function clearSlotAt(uint256 bitmap, uint8 index) internal pure returns (uint256) {
        return bitmap & ~_mask(index);
    }
}