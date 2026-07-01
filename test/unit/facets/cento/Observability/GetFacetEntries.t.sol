// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {ObservabilityTestSetup} from "./AAA/Setup.sol";

contract GetFacetEntriesTest is ObservabilityTestSetup {

    function test_GetFacetEntries_ReturnsFacets() public {
        // array is sorted for simplicity of comparison
        Facet[] memory expected = FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB
        ))._out();
        arrange_FacetsAt(expected);
        Facet[] memory actual = when_GetFacetEntries();
        then_FacetArraysMatch(actual, expected);
    }

}