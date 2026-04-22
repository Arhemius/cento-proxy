// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { DiamondLib } from "../libraries/DiamondLib.sol";
import { FacetStorage } from "../structs/FacetStorage.sol";
import { Facet } from "../structs/Facet.sol";
import { IERC165 } from "../interfaces/IERC165.sol";
import { IObservability } from "../interfaces/IObservability.sol";


contract Observability is IERC165, IObservability {

    function getFacets() external override view returns (address[] memory active) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();

        uint256 len = fs.facets.length;
        uint256 count;

        // first pass: count active
        for (uint256 i; i < len; i++) {
            if (fs.facets[i] != address(0)) {
                count++;
            }
        }

        active = new address[](count);

        // second pass: fill
        uint256 j;
        for (uint256 i; i < len; i++) {
            address f = fs.facets[i];
            if (f != address(0)) {
                active[j++] = f;
            }
        }
    }

    function getFacetsWithIndex() external override view returns (Facet[] memory result) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();

        uint256 len = fs.facets.length;
        uint256 count;

        for (uint256 i; i < len; i++) {
            if (fs.facets[i] != address(0)) {
                count++;
            }
        }

        result = new Facet[](count);

        uint256 j;
        for (uint256 i; i < len; i++) {
            address f = fs.facets[i];
            if (f != address(0)) {
                result[j] = Facet({
                    facet: f,
                    index: i
                });
                j++;
            }
        }
    }

    function supportsInterface(bytes4 _interfaceId) external override view returns (bool) {
        FacetStorage storage fs = DiamondLib.loadBaseSlot();
        return fs.supportedInterfaces[_interfaceId];
    }
}