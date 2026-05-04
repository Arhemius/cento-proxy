// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { LibCento as lc } from "../libraries/LibCento.sol";
import { LibBitmap as lb } from "../libraries/LibBitmap.sol";
import { CentoStorage as CS } from "../structs/CentoStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { IObservability } from "../interfaces/IObservability.sol";

contract Observability is IERC165, IObservability {
    using lb for uint256;

    function getFacets() external override view returns (address[] memory result) {
        CS storage cs = lc._cs();
        uint8 index;
        uint256 bitmap = cs.indexBitmap;
        result = new address[](bitmap.countFilledSlots());
        for (uint8 i; bitmap != 0;) {
            (bitmap, index) = bitmap.popFirstFilledSlot();
            result[i++] = cs.facets[index];
        }
    }

    function getFacetEntries() external override view returns (Facet[] memory result) {
        CS storage cs = lc._cs();
        uint8 index;
        uint256 bitmap = cs.indexBitmap;
        result = new Facet[](bitmap.countFilledSlots());
        for (uint8 i; bitmap != 0;) {
            (bitmap, index) = bitmap.popFirstFilledSlot();
            result[i++] = Facet({index: index, facet: cs.facets[index]});
        }
    }

    function getFacetAt(uint8 index) external override view returns (address facet) {
        CS storage cs = lc._cs();
        facet = cs.facets[index];
    }

    function getFirstFreeSlot() external override view returns (uint8 index) {
        CS storage cs = lc._cs();
        index = cs.indexBitmap.getFirstEmptySlot();
    }

    function supportsInterface(bytes4 _interfaceId) external override view returns (bool) {
        CS storage cs = lc._cs();
        return cs.supportedInterfaces[_interfaceId];
    }
}