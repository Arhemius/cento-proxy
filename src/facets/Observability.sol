// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { DiamondLib } from "../libraries/DiamondLib.sol";
import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { IObservability } from "../interfaces/IObservability.sol";

contract Observability is IERC165, IObservability {

    uint256 internal constant DEBRUIJN64_MAGIC = 0x03f79d71b4cb0a89;
    bytes32 internal constant DEBRUIJN64_TABLE_0 = 0x050c12181e21272d162b3335243b373e04111d262a323a3d031c313902300100;
    bytes32 internal constant DEBRUIJN64_TABLE_1 = 0x0607080d09130e190a1f14220f281a2e0b17202c153423361025293c1b382f3f;

    function _unsafeToUint64(uint256 x) private pure returns (uint64 r) {
        assembly {
            r := x
        }
    }

    function _ctz64(uint64 x) private pure returns (uint8 r) {
        unchecked {
            assert(x != 0);
            uint256 idx = (uint256(x) * DEBRUIJN64_MAGIC) >> 58;
            bytes32 word = idx < 32 ? DEBRUIJN64_TABLE_0 : DEBRUIJN64_TABLE_1;
            assembly {
                r := byte(and(idx, 31), word)
            }
        }
    }

    function _lsbIndex(uint256 lsb) private pure returns (uint8) {
        unchecked {
            assert(lsb != 0);
            assert((lsb & (lsb - 1)) == 0);
            if ((lsb & type(uint64).max) != 0)          return _ctz64(_unsafeToUint64(lsb));
            if (((lsb >> 64) & type(uint64).max) != 0)  return _ctz64(_unsafeToUint64(lsb >> 64)) + 64;
            if (((lsb >> 128) & type(uint64).max) != 0) return _ctz64(_unsafeToUint64(lsb >> 128)) + 128;
                                                        return _ctz64(_unsafeToUint64(lsb >> 192)) + 192;
        }
    }

    function getFacets() external view returns (address[] memory result) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();
        uint256 bitmap = fs.indexBitmap;
        uint256 count;
        for (uint256 tmp = bitmap; tmp != 0; tmp &= (tmp - 1)) count++;
        result = new address[](count);
        uint256 i;
        while (bitmap != 0) {
            uint256 lsb = bitmap & (~bitmap + 1);
            uint8 index = _lsbIndex(lsb);
            result[i++] = fs.facets[index];
            bitmap ^= lsb;
        }
    }

    function getFacetEntries() external view returns (Facet[] memory result) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();
        uint256 bitmap = fs.indexBitmap;
        uint256 count;
        for (uint256 tmp = bitmap; tmp != 0; tmp &= (tmp - 1)) count++;
        result = new Facet[](count);
        uint256 i;
        while (bitmap != 0) {
            uint256 lsb = bitmap & (~bitmap + 1);
            uint8 index = _lsbIndex(lsb);
            result[i++] = Facet({index: index, facet: fs.facets[index]});
            bitmap ^= lsb;
        }
    }

    function getBitmap() external view returns (uint256) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();
        return fs.indexBitmap;
    }

    function supportsInterface(bytes4 _interfaceId) external override view returns (bool) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();
        return fs.supportedInterfaces[_interfaceId];
    }
}