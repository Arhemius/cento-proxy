// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Facet_, Facets, FacetLib } from "./FacetArrayLib.sol";

function FacetArr(bytes memory data) pure returns (Facets memory) {
    return FacetLib.from(data);
}

function FacetArr_(bytes memory data) pure returns (Facet_[] memory) {
    return FacetArr(data).out();
}