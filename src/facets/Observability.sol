// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { LibCento } from "../libraries/LibCento.sol";
import { LibBitmap } from "../libraries/LibBitmap.sol";
import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { IObservability } from "../interfaces/IObservability.sol";

contract Observability is IERC165, IObservability {

    function getFacets() external view returns (address[] memory result) {
        FacetStorage storage fs = LibCento.loadBaseSlot();
        uint256 bitmap = fs.indexBitmap;
        result = new address[](LibBitmap.countFilledSlots(bitmap));
        uint8 i;
        uint8 index;
        while (bitmap != 0) {
            (bitmap, index) = LibBitmap.popFirstFilledSlot(bitmap);
            result[i++] = fs.facets[index];
        }
    }

    function getFacetEntries() external view returns (Facet[] memory result) {
        FacetStorage storage fs = LibCento.loadBaseSlot();
        uint256 bitmap = fs.indexBitmap;
        result = new Facet[](LibBitmap.countFilledSlots(bitmap));
        uint8 i;
        uint8 index;
        while (bitmap != 0) {
            (bitmap, index) = LibBitmap.popFirstFilledSlot(bitmap);
            result[i++] = Facet({index: index, facet: fs.facets[index]});
        }
    }

    function getBitmap() external view returns (uint256) {
        FacetStorage storage fs = LibCento.loadBaseSlot();
        return fs.indexBitmap;
    }

    function supportsInterface(bytes4 _interfaceId) external override view returns (bool) {
        FacetStorage storage fs = LibCento.loadBaseSlot();
        return fs.supportedInterfaces[_interfaceId];
    }
}