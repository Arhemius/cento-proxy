// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoTestSetup} from "../integration/cento/_Setup.sol";
import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {LibCentoPureAssert} from "test/unit/libraries/cento/LibCento/AAA/PureAssert.sol";

contract CentoLifecycleTest is CentoTestSetup, LibCentoPureAssert {

    function test_CentoLifecycle() public {
        uint8 facetIndex = 3;

        Facet[] memory before = CentoProxy.getFacetEntries();
        then_FacetArraysMatch(before, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability
        ))._out());

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(),
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        Facet[] memory afterOwnerUpdate = CentoProxy.getFacetEntries();
        then_FacetArraysMatch(afterOwnerUpdate, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability, 3, facetA
        ))._out());

        vm.prank(owner);
        CentoProxy.transferOwnership(user);

        vm.prank(user);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetB))._out(),
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        Facet[] memory afterUserUpdate = CentoProxy.getFacetEntries();
        then_FacetArraysMatch(afterUserUpdate, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability, 3, facetB
        ))._out());
    }
}