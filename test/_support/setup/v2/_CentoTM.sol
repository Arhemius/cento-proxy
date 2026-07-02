// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoTest} from "./Base.t.sol";
import {Facet} from "cento/structs/Facet.sol";
import {$CentoProxyV2} from "interaction/CentoV2.sol";
import {FacetManager} from "src/cento/facets/FacetManager.sol";
import {Ownership} from "src/cento/facets/Ownership.sol";
import {Observability} from "src/cento/facets/Observability.sol";

abstract contract CentoTM is CentoTest {

    address private testTarget;

    function setUp() public virtual {
        _create();
        _bind();
        _bootstrap();
        _setup();
    }

    // ---------------------------------------------------------------------
    // Phase 1: construct system under test
    // ---------------------------------------------------------------------

    function _create() internal virtual {
        facetManager  = address(new FacetManager());
        ownership     = address(new Ownership());
        observability = address(new Observability());
    }

    function target(address _target) internal {
        testTarget = _target;
    }

    // ---------------------------------------------------------------------
    // Phase 2: connect test harness to system
    // ---------------------------------------------------------------------

    function _bind() internal virtual {
        CentoProxy = $CentoProxyV2.wrap(testTarget);
        cento = testTarget;
    }

    // ---------------------------------------------------------------------
    // Phase 3: protocol bootstrap
    // ---------------------------------------------------------------------

    function _bootstrap() internal virtual {}
    

    function install(Facet[] memory setF, bytes4[] memory addI) internal {
        address currentOwner = CentoProxy.owner();
        vm.prank(currentOwner);
        CentoProxy.atomicUpdate(setF, addI, NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
    }

    function initialize(address migrator, bytes memory data) internal {
        address currentOwner = CentoProxy.owner();
        vm.prank(currentOwner);
        CentoProxy.atomicUpdate(NO_FACETS(), NO_INTERFACES(), NO_INTERFACES(), migrator, data);
    }

    function setOwner(address newOwner) internal {
        address currentOwner = CentoProxy.owner();
        vm.prank(currentOwner);
        CentoProxy.transferOwnership(newOwner);
    }

    // ---------------------------------------------------------------------
    // Phase 4: scenario initialization (use this in tests)
    // ---------------------------------------------------------------------

    function _setup() internal virtual {}
}