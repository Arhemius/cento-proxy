// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/FacetArray/FacetArray.sol";
import "support/etl/BytesNArray/Bytes4Array.sol";
import {LibCentoTestSetup} from "./AAA/Setup.sol";
import {console2} from "forge-std/console2.sol";
import {Facet} from "src/structs/Facet.sol";

contract AtomicUpdateTest is LibCentoTestSetup {

    function test_Atomic_EventSequence() public {

        arrange_Interfaces(B4_(abi.encode(0x9bad0345, 0x8dabe674)));
        arrange_FacetsAt(FacetArr(abi.encode(
            1, facetA,  2, facetA,  3, facetB,
            4, facetB,  5, facetA,  6, facetA
        ))._out());

        Facet_[]  memory remF = FacetArr_(abi.encode(4, address(0),  5, address(0),  6, address(0)));
        Facet_[]  memory updF = FacetArr_(abi.encode(1, facetB,      2, facetB,      3, facetA));
        Facet_[]  memory addF = FacetArr_(abi.encode(7, facetA,      8, facetB,      9, facetA));

        Facet_[]  memory setF = new Facet_[](remF.length + updF.length + addF.length); uint256 k;
        for (uint256 i; i < remF.length; i++) setF[k++] = remF[i];
        for (uint256 i; i < updF.length; i++) setF[k++] = updF[i];
        for (uint256 i; i < addF.length; i++) setF[k++] = addF[i];

        bytes4[]  memory addI    = B4_(abi.encode(0xabcdef12, 0x12345678));
        bytes4[]  memory remI    = B4_(abi.encode(0x9bad0345, 0x8dabe674));
        address[] memory updOldF = h.getFacetsAt(Facets({data: updF}).indices());
        address[] memory remOldF = h.getFacetsAt(Facets({data: remF}).indices());
        bytes     memory data    = given_MigratorCall(WRITE_VALUE, abi.encode(42));

        recordLogs(); when_AtomicUpdate(Facets({data: setF})._out(), addI, remI, migrator, data);

        then_MatchesEvents(address(lc), AtomicUpdate(
            FacetsRemoved(remF, remOldF),
            FacetsUpdated(updF, updOldF), 
            FacetsAdded(addF),
            InterfacesAdded(addI), 
            InterfacesRemoved(remI), 
            StorageMigrationSucceeded(migrator) 
        ));
    }
}

    // function test_etch7702Code() public view {
    //     bytes3 prefix;
    //     bytes3 expectedPrefix = 0xef0100;
    //     address target = eip7702Eoa;
    //     assembly {
    //         extcodecopy(target, 0x00, 0, 3)
    //         prefix := mload(0x00)
    //     }
    //     console2.logBytes(abi.encodePacked(prefix));
    //     console2.logAddress(owner);
    //     assertEq(prefix, expectedPrefix, "Code prefix mismatch");
    // }