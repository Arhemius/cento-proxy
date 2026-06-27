// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/FacetArray/FacetArray.sol";
import {Facet} from "src/structs/Facet.sol";
import {FacetManagerTestSetup} from "./AAA/Setup.sol";

contract AtomicUpdateTest is FacetManagerTestSetup {

    function test_Atomic_WhenOwner_ExecutesUpdate() public {
        arrange_Owner(owner);
        Facet[] memory addF = FacetArr(abi.encode(1, facetA,  2, facetB,  3, facetA))._out();
        vm.prank(owner);
        when_AtomicUpdate(__, addF, NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        then_FacetsAt(addF);
    }

    function test_Atomic_WhenUser_Reverts() public {
        arrange_Owner(owner);
        Facet[] memory addF = FacetArr(abi.encode(1, facetA,  2, facetB,  3, facetA))._out();
        vm.prank(user);
        when_AtomicUpdate(errors, addF, NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        then_MatchesError(NotContractOwner(user));
    }
}