// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoRouterTestSetup} from "./AAA/Setup.sol";
import {Cento} from "interaction/Cento.sol";
import "support/etl/BytesNArray/Bytes4Array.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";
import {OwnershipAdapter} from "support/adapters/OwnershipAdapter.sol";
import {ObservabilityAdapter} from "support/adapters/ObservabilityAdapter.sol";

contract ConstructorTest is CentoRouterTestSetup {

    function lc_create() internal override {
        facetManager  = address(new FacetManagerAdapter());
        observability = address(new ObservabilityAdapter());
        ownership     = address(new OwnershipAdapter());
    }

    function test_Constructor_AddsFacets() public {
        when_ConstructCentoProxy(owner, [facetManager, ownership, observability]);
        then_FacetAt(Cento.FACET_MANAGER, facetManager);
        then_FacetAt(Cento.OWNERSHIP,     ownership);
        then_FacetAt(Cento.OBSERVABILITY, observability);
    }

    function test_Constructor_AddsInterfaces() public {
        when_ConstructCentoProxy(owner, [facetManager, ownership, observability]);
        then_InterfacesSupported(B4_(abi.encode(i4, i5, i6, i7)));
    }

    function test_Constructor_AddsOwner() public {
        when_ConstructCentoProxy(owner, [facetManager, ownership, observability]);
        then_OwnerIs(owner);
    }

}