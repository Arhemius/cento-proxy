// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {ObservabilityTestSetup} from "./AAA/Setup.sol";

contract GetFacetAtTest is ObservabilityTestSetup {

    function test_GetFacetAt_ReturnsFacet() public {
        // array is sorted for simplicity of comparison
        Facet[] memory facets = FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB
        ))._out();
        arrange_FacetsAt(facets);
        address actual = when_GetFacetAt(facets[1].index);
        then_FacetAddressesMatch(actual, facets[1].facet);
    }

}