// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { LibCento as lc } from "../libraries/LibCento.sol";
import { bitmap256, u } from "../libraries/LibBitmap.sol";
import { CentoStorage as CS } from "../structs/CentoStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { IObservability } from "../interfaces/IObservability.sol";

contract Observability is IERC165, IObservability {

    function getFacets() external override view returns (address[] memory result) {
        CS storage cs = lc._cs();
        uint8 index; uint16 i;
        bitmap256 bitmap = cs.indexBitmap;
        result = new address[](256);
        while (u(bitmap) != 0) {
            (bitmap, index) = bitmap.popFirstFilledSlot();
            result[i++] = cs.facets[index];
        } assembly { mstore(result, i) }
    }

    function getFacetEntries() external override view returns (Facet[] memory result) {
        CS storage cs = lc._cs();
        uint8 index; uint16 i;
        bitmap256 bitmap = cs.indexBitmap;
        result = new Facet[](256);
        while (u(bitmap) != 0) {
            (bitmap, index) = bitmap.popFirstFilledSlot();
            result[i++] = Facet({index: index, facet: cs.facets[index]});
        } assembly { mstore(result, i) }
    }

    function getFacetAt(uint8 index) external override view returns (address facet) {
        CS storage cs = lc._cs();
        facet = cs.facets[index];
    }

    function getFacetCount() external override view returns (uint16 count) {
        CS storage cs = lc._cs();
        count = cs.indexBitmap.countFilledSlots();
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