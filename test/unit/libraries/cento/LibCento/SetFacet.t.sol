// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTestSetup} from "./AAA/Setup.sol";
import {bitmap256} from "cento/types/bitmap256.sol";

contract SetFacetTest is LibCentoTestSetup {

    /*//////////////////////////////////////////////////////////////
                                STORAGE
    //////////////////////////////////////////////////////////////*/

    function test_SetF_EmptySlot_PopulatesStorage() public {
        when_SetFacet(__, 7, facetA);
        then_FacetAt(     7, facetA);
    }

    function test_SetF_EmptySlot_FillsBitmap() public {
        bitmap256 bitmap = when_SetFacet(__, 7, facetA);
        then_SlotOccupied(bitmap, 7);
    }

    function test_SetF_OccupiedSlot_ReplacesStorage() public {
        arrange_FacetAt(  7, facetA);
        when_SetFacet(__, 7, facetB);
        then_FacetAt(     7, facetB);
    }

    function test_SetF_OccupiedSlot_LeavesBitmapUnchanged() public {
        arrange_FacetAt(  7, facetA);
        bitmap256 before = h.bitmap();
        bitmap256 _after = when_SetFacet(__, 7, facetB);
        then_BitmapIs(_after, before);
    }

    function test_SetF_RemoveFacet_ClearsStorage() public {
        arrange_FacetAt(  7, facetA);
        when_SetFacet(__, 7, address(0));
        then_FacetIsZero( 7);
    }

    function test_SetF_RemoveFacet_ClearsBitmap() public {
        arrange_FacetAt(  7, facetA);
        bitmap256 bitmap = when_SetFacet(__, 7, address(0));
        then_SlotEmpty(bitmap, 7);
    }

    function test_SetF_SameFacet_LeavesStorageUnchanged() public {
        arrange_FacetAt(  7, facetA);
        when_SetFacet(__, 7, facetA);
        then_FacetAt(     7, facetA);
        then_AllFacetsZeroExcept(7);
    }

    function test_SetF_SameFacet_LeavesBitmapUnchanged() public {
        arrange_FacetAt(  7, facetA);
        bitmap256 before = h.bitmap();
        bitmap256 _after = when_SetFacet(__, 7, facetA);
        then_BitmapIs(_after, before);
    }

    function test_SetF_AllSlotsFilled_TreatsNewFacetAsUpdate() public {
        arrange_FullFacetArray(facetA);
        bitmap256 bitmap = when_SetFacet(__, 42, facetB);
        then_FacetAt(42, facetB);
        then_SlotOccupied(bitmap, 42);
    }

    function test_SetF_Index0_PopulatesStorage() public {
        when_SetFacet(__, 0, facetA);
        then_FacetAt(     0, facetA);
    }

    function test_SetF_Index255_PopulatesStorage() public {
        when_SetFacet(__, 255, facetA);
        then_FacetAt(     255, facetA);
    }


    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    function test_SetF_ZeroFacetForEmptySlot_Reverts() public {
        when_SetFacet(errors, 7, address(0));
        then_MatchesError(ZeroFacetForEmptySlot());
    }

    function test_SetF_RouterAsFacet_Reverts() public {
        when_SetFacet(errors, 7, address(lc));
        then_MatchesError(RouterAsFacetForbidden());
    }

    function test_SetF_InvalidFacet_Reverts() public {
        when_SetFacet(errors, 7, user);
        then_Reverted();
    }
}