// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/FacetArray/FacetArray.sol";
import {Facet} from "cento/structs/Facet.sol";
import {ObservabilityTestSetup} from "./AAA/Setup.sol";

contract GetFacetStateTest is ObservabilityTestSetup {

    function test_GetFacets_ReturnsFacetAddresses() public {
        Facets memory $facets = FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB
        ));
        arrange_FacetsAt($facets._out());
        address[] memory expected = $facets.facets();
        address[] memory actual   = when_GetFacets();
        then_FacetArrayAddressesMatch(actual, expected);
    }

    function test_GetFacetCount_ReturnsCount() public {
        Facets memory $facets = FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB
        ));
        arrange_FacetsAt($facets._out());
        uint16 expected = uint16($facets.data.length);
        uint16 actual = when_GetFacetCount();
        then_CountIs(actual, expected);
    }

    function test_GetFirstFreeSlot_ReturnsIndex() public {
        Facets memory $facets = FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB
        ));
        arrange_FacetsAt($facets._out());
        uint8 actual = when_GetFirstFreeSlot(__);
        then_IndexIs(actual, 0);
    }

    function test_GetFirstFreeSlot_Reverts() public {
        arrange_FullFacetArray(facetA);
        when_GetFirstFreeSlot(errors);
        then_MatchesError(NoFreeSlots());
    }

}