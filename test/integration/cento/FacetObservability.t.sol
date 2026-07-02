// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoTestSetup} from "./_Setup.sol";
import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {LibCentoPureAssert} from "test/unit/libraries/cento/LibCento/AAA/PureAssert.sol";

contract FacetObservabilityTest is CentoTestSetup, LibCentoPureAssert {

    function test_FacetObservability_DetectsFacets() public {
        uint8 facetIndex = 3;

        address[] memory facets = CentoProxy.getFacets();
        then_FacetArrayAddressesMatch(facets, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability
        )).facets());

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        facets = CentoProxy.getFacets();
        then_FacetArrayAddressesMatch(facets, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability, 3, facetA
        )).facets());
    }
    
    function test_FacetObservability_DetectsFacetEntries() public {
        uint8 facetIndex = 3;

        Facet[] memory facets = CentoProxy.getFacetEntries();
        then_FacetArraysMatch(facets, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability
        ))._out());

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        facets = CentoProxy.getFacetEntries();
        then_FacetArraysMatch(facets, FacetArr(abi.encode(
            0, facetManager, 1, ownership, 2, observability, 3, facetA
        ))._out());
    }

    function test_FacetObservability_DetectsFacetAt() public {
        uint8 facetIndex = 3;

        address facet = CentoProxy.getFacetAt(facetIndex);
        then_FacetAddressesMatch(facet, address(0));

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        facet = CentoProxy.getFacetAt(facetIndex);
        then_FacetAddressesMatch(facet, facetA);
    }

    function test_FacetObservability_DetectsFacetCount() public {
        uint8 facetIndex = 3;

        uint16 facetCount = CentoProxy.getFacetCount();
        assertEq(facetCount, 3);

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        facetCount = CentoProxy.getFacetCount();
        assertEq(facetCount, 4);
    }

    function test_FacetObservability_DetectsFirstFreeSlot() public {
        uint8 facetIndex = 3;

        uint8 firstFreeSlot = CentoProxy.getFirstFreeSlot();
        assertEq(firstFreeSlot, 3);

        vm.prank(owner);
        CentoProxy.atomicUpdate(
            FacetArr(abi.encode(facetIndex, facetA))._out(), 
            NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        firstFreeSlot = CentoProxy.getFirstFreeSlot();
        assertEq(firstFreeSlot, 4);
    }

    function test_FacetObservability_DetectsNewInterface() public {
        bool isSupported = CentoProxy.supportsInterface(i1);
        then_SupportStatusMatches(isSupported, false);

        vm.prank(owner);
        CentoProxy.atomicUpdate( NO_FACETS(), 
            B4_(abi.encode(i1)), NO_INTERFACES(), NO_ADDRESS(), NO_DATA()
        );

        isSupported = CentoProxy.supportsInterface(i1);
        then_SupportStatusMatches(isSupported, true);
    }
}