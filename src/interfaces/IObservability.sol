// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Facet } from "../structs/Facet.sol";

interface IObservability {

    function getFacets() external view returns (address[] memory active);

    function getFacetEntries() external view returns (Facet[] memory result);

    function getBitmap() external view returns (uint256);
    
}