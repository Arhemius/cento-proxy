// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {CentoTM} from "support/setup/v1/_CentoTM.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {Dummies} from "support/fixtures/dummies/Dummies.sol";

contract AtomicUpdateGasTest is CentoTM, Dummies, SimpleActors, GasReportLogger {

    function _create() internal override {
        super._create();
        CentoRouter cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );  target(address(cento));
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
        setWidths(26, 10, 11);
        vm.startPrank(owner);
    }

    function test_00_00_header() public view {
        table("GetFacetEntries (Cento)");
    }

    function test_01_00_getFacetEntries_baseline() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_1, NO_ADDRESS(),
            DUMMY_2, NO_ADDRESS(),
            DUMMY_3, NO_ADDRESS(),
            DUMMY_4, NO_ADDRESS(),
            DUMMY_5, NO_ADDRESS()
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        CentoProxy.getFacetEntries();
        CentoProxy.getFacetEntries();
        th("getFacetEntries", "baseline");
    }

    function test_01_01_getFacetEntries_4() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_2, NO_ADDRESS(),
            DUMMY_3, NO_ADDRESS(),
            DUMMY_4, NO_ADDRESS(),
            DUMMY_5, NO_ADDRESS()
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        CentoProxy.getFacetEntries();
        CentoProxy.getFacetEntries();
        tr("getFacetEntries", "4 facets");
    }

    function test_01_02_getFacetEntries_5() public {
        CentoProxy.atomicUpdate(FacetArr(abi.encode(
            DUMMY_3, NO_ADDRESS(),
            DUMMY_4, NO_ADDRESS(),
            DUMMY_5, NO_ADDRESS()
        ))._out(), NO_INTERFACES(), NO_INTERFACES(), NO_ADDRESS(), NO_DATA());
        CentoProxy.getFacetEntries();
        CentoProxy.getFacetEntries();
        tr("getFacetEntries", "5 facets");
    }

    function test_01_03_getFacetEntries_8() public {
        CentoProxy.getFacetEntries();
        CentoProxy.getFacetEntries();
        tr("getFacetEntries", "8 facets");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   ======== Isolation mode ========

//   [Gas]    ╭─ GetFacetEntries (Cento) ──╮
//   [Gas]    │                            ├────────────┬────────────╮
//   [Gas]    │ getFacetEntries            │ 3 facets   │ 15,242 gas │
//   [Gas]    │                            │ 4 facets   │ 18,434 gas │
//   [Gas]    │                            │ 5 facets   │ 21,626 gas │
//   [Gas]    │                            │ 8 facets   │ 31,227 gas │
//   [Gas]    ╰────────────────────────────┴────────────┴────────────╯