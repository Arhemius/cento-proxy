// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {CentoTM} from "support/setup/v1/_CentoTM.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {Dummies} from "support/fixtures/dummies/Dummies.sol";
import {$CentoProxyV1} from "interaction/CentoV1.sol";

contract AtomicUpdateGasTest is CentoTM, Dummies, SimpleActors, GasReportLogger {

    $CentoProxyV1 internal CentoProxyAdd;

    function _create() internal override {
        super._create();
        CentoRouter cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );  target(address(cento));
        CentoProxyAdd = $CentoProxyV1.wrap(address(new CentoRouter(
            owner, [facetManager, ownership, observability]
        )));
    }

    function _bootstrap() internal override {
        install(FacetArr(abi.encode(
            DUMMY_1, dummy1v1,
            DUMMY_2, dummy2v1,
            DUMMY_3, dummy3v1,
            DUMMY_4, dummy4v1,
            DUMMY_5, dummy5v1
        ))._out(), NO_INTERFACES());
    }

    function _setup() internal override {
        setWidths(22, 10, 13);
        vm.startPrank(owner);
    }

    function test_00_00_header() public view {
        table("AtomicUpdate (Cento)");
    }

    // ========== Add Facets ==========

    function test_01_00_addFacet_1() public {
        CentoProxyAdd.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, dummy1v1
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        th("atomicUpdate", "addF (1)");
    }

    function test_01_01_addFacet_2() public {
        CentoProxyAdd.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, dummy1v1,
            DUMMY_2, dummy2v1
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "addF (2)");
    }

    function test_01_02_addFacet_5() public {
        CentoProxyAdd.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, dummy1v1,
            DUMMY_2, dummy2v1,
            DUMMY_3, dummy3v1,
            DUMMY_4, dummy4v1,
            DUMMY_5, dummy5v1
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "addF (5)");
        hr();
    }

    // ========== Update Facets ==========

    function test_02_00_updFacet_1() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, dummy1v2
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        th("atomicUpdate", "updF (1)");
    }

    function test_02_01_updFacet_2() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, dummy1v2,
            DUMMY_2, dummy2v2
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "updF (2)");
    }

    function test_02_02_updFacet_5() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, dummy1v2,
            DUMMY_2, dummy2v2,
            DUMMY_3, dummy3v2,
            DUMMY_4, dummy4v2,
            DUMMY_5, dummy5v2
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "updF (5)");
        hr();
    }

    // ========== Remove Facets ==========

    function test_03_00_remFacet_1() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, NO_ADDRESS()
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        th("atomicUpdate", "remF (1)");
    }

    function test_03_01_remFacet_2() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, NO_ADDRESS(),
            DUMMY_2, NO_ADDRESS()
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "remF (2)");
    }

    function test_03_02_remFacet_5() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, NO_ADDRESS(),
            DUMMY_2, NO_ADDRESS(),
            DUMMY_3, NO_ADDRESS(),
            DUMMY_4, NO_ADDRESS(),
            DUMMY_5, NO_ADDRESS()
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        tr("atomicUpdate", "remF (5)");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   ======== Isolation mode (the only reliable mode for measurement, despite overhead) ========

//   [Gas]    ╭─ AtomicUpdate (Cento) ─╮
//   [Gas]    │                        ├────────────┬──────────────╮
//   [Gas]    │ atomicUpdate           │ addF (1)   │   65,739 gas │
//   [Gas]    │                        │ addF (2)   │   92,382 gas │
//   [Gas]    │                        │ addF (5)   │  172,264 gas │
//   [Gas]    ├────────────────────────┼────────────┼──────────────┤
//   [Gas]    │ atomicUpdate           │ updF (1)   │   45,793 gas │
//   [Gas]    │                        │ updF (2)   │   55,278 gas │
//   [Gas]    │                        │ updF (5)   │   83,722 gas │
//   [Gas]    ├────────────────────────┼────────────┼──────────────┤
//   [Gas]    │ atomicUpdate           │ remF (1)   │   40,776 gas │
//   [Gas]    │                        │ remF (2)   │   42,456 gas │
//   [Gas]    │                        │ remF (5)   │   57,160 gas │
//   [Gas]    ╰────────────────────────┴────────────┴──────────────╯