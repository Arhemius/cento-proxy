// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/FacetArray/FacetArray.sol";
import "support/etl/BytesNArray/Bytes4Array.sol";
import {LibCentoTestSetup} from "./AAA/Setup.sol";
import {bitmap256, w} from "cento/libraries/LibBitmap.sol";
import {StorageMigrator} from "support/fixtures/Migrator.sol";
// import {Facet} from "cento/structs/Facet.sol";

contract AtomicUpdateTest is LibCentoTestSetup {

    function lc_setup() internal override {
        arrange_Interfaces(B4_(abi.encode(i1, i2)));
        arrange_FacetsAt(FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB,
            4, facetB,  5, facetA,  6, facetA
        ))._out());
    }

    function test_Atomic_FacetBitmapCSI() public {
       (,,, Facet_[]  memory setF,,, ) = prepareInputs();
        when_AtomicUpdate(__, Facets({data: setF})._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        bitmap256 bitmap = h.bitmap();
        then_FacetBitmapCSI_Holds(bitmap);
    }

    function test_Atomic_Interfaces_MatchExpected() public {
       (,,,, bytes4[] memory addI, bytes4[] memory remI,) = prepareInputs();
        when_AtomicUpdate(__, NO_FACETS(), addI, remI, NO_ADDRESS(), NO_DATA());
        then_InterfacesSupported(addI);
        then_InterfacesNotSupported(remI);
    }

    function test_Atomic_StorageBitmap_MatchesExpected() public {
       (Facet_[]  memory remF,, Facet_[] memory addF, Facet_[]  memory setF,,,) = prepareInputs();
        bitmap256 bitmap = expectedBitmap(h.bitmap(), remF, addF);
        when_AtomicUpdate(__, Facets({data: setF})._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        then_StorageBitmap_Is(bitmap);
    }

    function test_Atomic_BitmapStorage_BeforeMigrator() public {
       (Facet_[]  memory remF,, Facet_[] memory addF, 
        Facet_[] memory setF,,, bytes    memory data) = prepareInputs();
        bitmap256 bitmap = expectedBitmap(h.bitmap(), remF, addF);
        when_AtomicUpdate(__, Facets({data: setF})._out(), NO_INTERFACES(), NO_INTERFACES(), migrator, data);
        bitmap256 new_bitmap = newBitmap();
        then_BitmapIs(new_bitmap, bitmap);
    }

    function test_Atomic_EventEmissionSequence() public {
       (Facet_[]  memory remF, Facet_[] memory updF, Facet_[] memory addF, 
        Facet_[]  memory setF, bytes4[] memory addI, bytes4[] memory remI, 
        bytes     memory data)                              = prepareInputs ();
       (address[] memory updOldF, address[] memory remOldF) = snapshotState (updF, remF);
        when_AtomicUpdate(events, Facets({data: setF})._out(), addI, remI, migrator, data);
        then_MatchesEvents(address(lc), AtomicUpdate(
            $FacetsRemoved(remF, remOldF),
            $FacetsUpdated(updF, updOldF), 
            $FacetsAdded(addF),  
            $InterfacesAdded(addI), 
            $InterfacesRemoved(remI),
            StorageMigrationSucceeded(migrator)
        ));
    }


    function prepareInputs() private view returns (
        Facet_[] memory remF, Facet_[] memory updF, Facet_[] memory addF, Facet_[] memory setF, 
        bytes4[] memory addI, bytes4[] memory remI, bytes    memory data
    ) {
        remF = FacetArr_(abi.encode(4, address(0),  5, address(0),  6, address(0)));
        updF = FacetArr_(abi.encode(1, facetB,      2, facetB,      3, facetA    ));
        addF = FacetArr_(abi.encode(7, facetA,      8, facetB,      9, facetA    ));

        setF = new Facet_[](remF.length + updF.length + addF.length); uint256 k;
        for (uint256 i; i < remF.length; i++) setF[k++] = remF[i];
        for (uint256 i; i < updF.length; i++) setF[k++] = updF[i];
        for (uint256 i; i < addF.length; i++) setF[k++] = addF[i];

        addI = B4_(abi.encode(i3, i4));
        remI = B4_(abi.encode(i1, i2));
        data = given_MigratorCall(OBSERVE_BITMAP);
    }

    function expectedBitmap(bitmap256 bitmap, Facet_[] memory remF, Facet_[] memory addF) private pure returns (bitmap256) {
        for (uint256 i; i < remF.length; i++) bitmap = bitmap.clearSlotAt(uint8(remF[i].index));
        for (uint256 i; i < addF.length; i++) bitmap = bitmap.fillSlotAt (uint8(addF[i].index));
        return bitmap;
    }

    function snapshotState(Facet_[] memory updF, Facet_[] memory remF) private view 
        returns (address[] memory updOldF, address[] memory remOldF) {
        updOldF = h.getFacetsAt(Facets({data: updF}).indices());
        remOldF = h.getFacetsAt(Facets({data: remF}).indices());
    }

    function newBitmap() private view returns (bitmap256 bitmap) {
        bitmap = w(uint256(h.TestSlot(Migrator.TEST_SLOT())));
    }
}


// Possible Application:

// then_MatchesEvents(address(lc), AtomicUpdate(
//     FacetsRemoved(remF, remOldF),
//     FacetsUpdated(updF, updOldF), 
//     FacetsAdded(addF),  
//     InterfacesAdded(addI), 
//     SKIP_EVENTS(),
//     SKIP_EVENT()
// ));
