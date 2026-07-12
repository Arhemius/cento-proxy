// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {FacetManagerTestSetup} from "test/unit/facets/cento/FacetManager/AAA/Setup.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {FacetManager} from "src/cento/facets/FacetManager.sol";
import {CentoArrange} from "test/gas/cento/AAA/Arrange.sol";

contract FacetManagerGasTest is FacetManagerTestSetup, CentoArrange, GasReportLogger {

    FacetManager internal FM;
    address internal fm_;

    function lc_create() internal virtual override {
        FM = new FacetManager();
        fm_ = address(FM);
    }

    function lc_setup() internal override {
        store_Owner(fm_, owner);
        setWidths(16, 10, 11);
        vm.startPrank(owner);
    }

    function test_00_00_header() public view {
        table("FacetManager");
    }

    // ========== baseline ==========

    function test_01_00_baseline() public {
        FM.atomicUpdate(NO_FACETS(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        th("atomicUpdate", "baseline");
        hr();
    }

    // ========== Facets ==========

    function test_02_00_addFacet_1() public {
        FM.atomicUpdate(FacetArr(abi.encode(
            1, facetA
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        th("atomicUpdate", "addF (1)");
    }

    function test_02_01_addFacet_2() public {
        FM.atomicUpdate(FacetArr(abi.encode(
            1, facetA, 2, facetB
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "addF (2)");
        hr();
    }

    // ========== Interfaces ==========

    function test_03_00_addInterface_1() public {
        FM.atomicUpdate(NO_FACETS(), B4_(abi.encode(
            i1
        )), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        th("atomicUpdate", "addI (1)");
    }

    function test_03_01_addInterface_2() public {
        FM.atomicUpdate(NO_FACETS(), B4_(abi.encode(
            i1, i2
        )), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "addI (2)");
    }

    function test_04_00_removeInterface_1() public {
        store_Interface(fm_, i1);
        FM.atomicUpdate(NO_FACETS(), NO_INTERFACES(), B4_(abi.encode(
            i1
        )), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "remI (1)");
    }

    function test_04_01_removeInterface_2() public {
        store_Interface(fm_, i1);
        store_Interface(fm_, i2);
        FM.atomicUpdate(NO_FACETS(), NO_INTERFACES(), B4_(abi.encode(
            i1, i2
        )), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "remI (2)");
        hr();
    }

    // ========== Migration ==========

    function test_05_00_callMigrator() public {
        FM.atomicUpdate(NO_FACETS(), NO_INTERFACES(), NO_INTERFACES(),
            migrator,
            abi.encodeCall(Migrator.dummy, ())
        );
        th("atomicUpdate", "callM");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ FacetManager ───╮
//   [Gas]    │                  ├────────────┬────────────╮
//   [Gas]    │ atomicUpdate     │ baseline   │  9,086 gas │
//   [Gas]    ├──────────────────┼────────────┼────────────┤
//   [Gas]    │ atomicUpdate     │ addF (1)   │ 55,097 gas │
//   [Gas]    │                  │ addF (2)   │ 81,208 gas │
//   [Gas]    ├──────────────────┼────────────┼────────────┤
//   [Gas]    │ atomicUpdate     │ addI (1)   │ 31,876 gas │
//   [Gas]    │                  │ addI (2)   │ 54,666 gas │
//   [Gas]    │                  │ remI (1)   │  9,970 gas │
//   [Gas]    │                  │ remI (2)   │ 10,854 gas │
//   [Gas]    ├──────────────────┼────────────┼────────────┤
//   [Gas]    │ atomicUpdate     │ callM      │ 13,841 gas │
//   [Gas]    ╰──────────────────┴────────────┴────────────╯