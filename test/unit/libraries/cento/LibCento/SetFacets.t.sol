// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/FacetArray/FacetArray.sol";
import {Facet} from "cento/structs/Facet.sol";
import { LibCentoTestSetup } from "./AAA/Setup.sol";
import { bitmap256 } from "cento/libraries/LibBitmap.sol";

contract SetFacetsTest is LibCentoTestSetup {

    /*//////////////////////////////////////////////////////////////
                            BATCH EXECUTION
    //////////////////////////////////////////////////////////////*/

    function test_SetFacets_AllApplied_AsSequentialSetFacetCalls() public {
        arrange_FacetsAt(FacetArr(abi.encode(
            1, facetA,  3, facetB, 5, facetA,
            2, facetA,  4, facetB  
        ))._out());
        Facet[] memory setF = FacetArr(abi.encode(
            1, facetA,  3, facetA,     5, facetB,
            2, facetB,  4, address(0), 6, facetA
        ))._out();
        bitmap256 bitmap = when_SetFacets(__, setF);
        then_FacetsAt(setF);
        then_FacetBitmapCSI_Holds(bitmap);
    }


    /*//////////////////////////////////////////////////////////////
                        STORAGE INVARIANT
    //////////////////////////////////////////////////////////////*/

    function test_SetFacets_BitmapMatchesStorage_Invariant() public {
        Facet[] memory setF = FacetArr(abi.encode(
            1, facetA, 3, facetA, 5, facetA,
            2, facetB, 4, facetB
        ))._out();
        bitmap256 bitmap = when_SetFacets(__, setF);
        then_FacetBitmapCSI_Holds(bitmap);
    }

    struct FacetOp {
        uint8 index;
        uint8 mode;
    }

    function testFuzz_SetFacets_BitmapConsistentWithStorage(FacetOp[] memory ops) public {
        vm.assume(ops.length > 0);
        vm.assume(ops.length <= 32);
        bitmap256 expected;
        bool[256] memory occupied;
        Facet[] memory setF = new Facet[](ops.length);
        uint256 n;
        for (uint256 i; i < ops.length; ++i) {
            uint8 index = ops[i].index;
            // Weighted generator:
            //   0      -> remove  (10%)
            //   1..4   -> facetA  (40%)
            //   5..9   -> facetB  (50%)
            uint8 r = ops[i].mode % 10;
            address facet;
            if (r == 0) {
                // Ignore illegal removals.
                if (!occupied[index]) continue;
                facet = address(0);
                occupied[index] = false;
                expected = expected.clearSlotAt(index);
            } else {
                facet = r < 5 ? facetA : facetB;
                if (!occupied[index]) {
                    occupied[index] = true;
                    expected = expected.fillSlotAt(index);
                }
            }
            setF[n++] = Facet({
                index: index,
                facet: facet
            });
        }
        assembly { mstore(setF, n) }
        bitmap256 actual = when_SetFacets(__, setF);
        then_BitmapIs(actual, expected);
        then_FacetBitmapCSI_Holds(actual);
    }

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    function test_SetFacets_EmitsAllExpectedEvents() public {
        Facet_[] memory setF = FacetArr_(abi.encode(
            1, facetA, 2, facetB, 3, facetA
        ));
        when_SetFacets(events, Facets({data: setF})._out());
        then_MatchesEvents(address(lc), FacetsAdded(setF));
    }

    function test_SetFacets_NoOp_EmitsNothing() public {
        Facet_[] memory setF = given_EmptyFacetArray();
        when_SetFacets(events, Facets({data: setF})._out());
        then_NoEvents();
    }


    /*//////////////////////////////////////////////////////////////
                                ERRORS
    //////////////////////////////////////////////////////////////*/

    function test_SetFacets_InvalidFacet_RevertsWholeBatch() public {
        Facet[] memory setF = FacetArr(abi.encode(
            1, facetA, 2, address(lc), 3, facetB
        ))._out();
        when_SetFacets(errors, setF);
        then_MatchesError(RouterAsFacetForbidden());
    }

    function test_SetFacets_NoCodeFacet_RevertsWholeBatch() public {
        Facet[] memory setF = FacetArr(abi.encode(
            1, facetA, 2, user, 3, facetB
        ))._out();
        when_SetFacets(errors, setF);
        then_MatchesError(NoCodeOrEOA(user));
    }

    function test_SetFacets_InvalidFacet_RevertsWithoutStateChanges() public {
        // === Arrange Initial State ===
        Facet[] memory initial = FacetArr(abi.encode(
            1, facetA,  2, facetA, 3, facetA
        ))._out();
        arrange_FacetsAt(initial);
        bitmap256 beforeBitmap = h.bitmap();

        // === Arrange Inputs ===
        Facet[] memory setF = FacetArr(abi.encode(
            1, facetB,  2, user,   3, address(0)
        ))._out();

        // === Execute ===
        bitmap256 bitmap = when_SetFacets(errors, setF);

        // === Assert  ===
        then_Reverted();
        then_FacetsAt(initial);
        then_BitmapIs(bitmap, beforeBitmap);
        then_FacetBitmapCSI_Holds(beforeBitmap);
    }
}