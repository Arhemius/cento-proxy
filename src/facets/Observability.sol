// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import { LibCento } from "../libraries/LibCento.sol";
import { LibBitmap } from "../libraries/LibBitmap.sol";
import { CentoStorage } from "../structs/CentoStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { IObservability } from "../interfaces/IObservability.sol";

contract Observability is IERC165, IObservability {

    function getFacets() external override view returns (address[] memory result) {
        CentoStorage storage cs = LibCento.loadBaseSlot();
        uint256 bitmap = cs.indexBitmap;
        result = new address[](LibBitmap.countFilledSlots(bitmap));
        uint8 i;
        uint8 index;
        while (bitmap != 0) {
            (bitmap, index) = LibBitmap.popFirstFilledSlot(bitmap);
            result[i++] = cs.facets[index];
        }
    }

    function getFacetEntries() external override view returns (Facet[] memory result) {
        CentoStorage storage cs = LibCento.loadBaseSlot();
        uint256 bitmap = cs.indexBitmap;
        result = new Facet[](LibBitmap.countFilledSlots(bitmap));
        uint8 i;
        uint8 index;
        while (bitmap != 0) {
            (bitmap, index) = LibBitmap.popFirstFilledSlot(bitmap);
            result[i++] = Facet({index: index, facet: cs.facets[index]});
        }
    }

    function getFacetAt(uint8 index) external override view returns (address facet) {
        CentoStorage storage cs = LibCento.loadBaseSlot();
        facet = cs.facets[index];
    }

    function getFirstFreeSlot() external override view returns (uint8 index) {
        CentoStorage storage cs = LibCento.loadBaseSlot();
        index = LibBitmap.getFirstEmptySlot(cs.indexBitmap);
        
    }

    function supportsInterface(bytes4 _interfaceId) external override view returns (bool) {
        CentoStorage storage cs = LibCento.loadBaseSlot();
        return cs.supportedInterfaces[_interfaceId];
    }
}