// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoRouterTestSetup} from "./AAA/Setup.sol";
import {CentoV1} from "interaction/CentoV1.sol";
import "support/builtins/Builtins.sol";
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
        then_FacetAt(CentoV1.FACET_MANAGER, facetManager);
        then_FacetAt(CentoV1.OWNERSHIP,     ownership);
        then_FacetAt(CentoV1.OBSERVABILITY, observability);
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