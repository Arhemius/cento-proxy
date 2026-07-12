// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {Facets as _Facets} from "support/fixtures/Facets.sol";
import {Interfaces} from "support/fixtures/Interfaces.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CentoArrange} from "test/gas/cento/AAA/Arrange.sol";
import {Observability} from "src/cento/facets/Observability.sol";

contract ObservabilityGasTest is GasReportLogger, CentoArrange, _Facets, Interfaces {

    Observability internal OBS;
    address internal obs;

    function setUp() public {
        OBS = new Observability();
        obs = address(OBS);
        setWidths(18, 10, 10);
    }

    function test_00_00_header() public view {
        table("Observability");
    }

    // ========== getFacets ==========

    function test_01_00_getFacets_Empty() public {
        OBS.getFacets();
        OBS.getFacets();
        th("getFacets", "empty");
    }

    function test_01_01_getFacets_1() public {
        store_Facets(obs, 1, facetA);
        OBS.getFacets();
        tr("getFacets", "1");
    }

    function test_01_02_getFacets_2() public {
        store_Facets(obs, 2, facetA);
        OBS.getFacets();
        tr("getFacets", "2");
    }

    function test_01_03_getFacets_5() public {
        store_Facets(obs, 5, facetA);
        OBS.getFacets();
        tr("getFacets", "5");
        hr();
    }

    // ========== getFacetEntries ==========

    function test_02_00_getFacetEntries_Empty() public {
        OBS.getFacetEntries();
        OBS.getFacetEntries();
        th("getFacetEntries", "empty");
    }

    function test_02_01_getFacetEntries_1() public {
        store_Facets(obs, 1, facetA);
        OBS.getFacetEntries();
        tr("getFacetEntries", "1");
    }

    function test_02_02_getFacetEntries_2() public {
        store_Facets(obs, 2, facetA);
        OBS.getFacetEntries();
        tr("getFacetEntries", "2");
    }

    function test_02_03_getFacetEntries_5() public {
        store_Facets(obs, 5, facetA);
        OBS.getFacetEntries();
        tr("getFacetEntries", "5");
        hr();
    }

    // ========== getFacetAt ==========

    function test_03_00_getFacetAt_Set() public {
        store_FacetAt(obs, 42, facetA);
        OBS.getFacetAt(42);
        th("getFacetAt", "set");
    }

    function test_03_01_getFacetAt_Free() public {
        OBS.getFacetAt(42);
        OBS.getFacetAt(42);
        tr("getFacetAt", "free");
        hr();
    }

    // ========== getFacetCount ==========

    function test_04_00_getFacetCount_Empty() public {
        OBS.getFacetCount();
        OBS.getFacetCount();
        th("getFacetCount", "empty");
    }

    function test_04_01_getFacetCount_Sparse() public {
        store_FacetsAt(obs,
            U8_(abi.encode(0, 64, 128, 192)),
            facetA
        );
        OBS.getFacetCount();
        tr("getFacetCount", "sparse (4)");
    }

    function test_04_02_getFacetCount_Full() public {
        store_AllExcept(obs, type(uint8).max, facetA);
        OBS.getFacetCount();
        tr("getFacetCount", "full");
        hr();
    }

    // ========== getFirstFreeSlot ==========

    function test_05_00_getFirstFreeSlot_0() public {
        store_AllExcept(obs, 0, facetA);
        OBS.getFirstFreeSlot();
        th("getFirstFreeSlot", "0");
    }

    function test_05_01_getFirstFreeSlot_64() public {
        store_AllExcept(obs, 64, facetA);
        OBS.getFirstFreeSlot();
        tr("getFirstFreeSlot", "64");
    }

    function test_05_02_getFirstFreeSlot_128() public {
        store_AllExcept(obs, 128, facetA);
        OBS.getFirstFreeSlot();
        tr("getFirstFreeSlot", "128");
    }

    function test_05_03_getFirstFreeSlot_255() public {
        store_AllExcept(obs, 255, facetA);
        OBS.getFirstFreeSlot();
        tr("getFirstFreeSlot", "255");
        hr();
    }

    // ========== supportsInterface ==========

    function test_06_00_supportsInterface_Set() public {
        store_Interface(obs, i1);
        OBS.supportsInterface(i1);
        th("supportsInterface", "set");
    }

    function test_06_01_supportsInterface_Free() public {
        OBS.supportsInterface(i1);
        OBS.supportsInterface(i1);
        tr("supportsInterface", "free");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ Observability ────╮
//   [Gas]    │                    ├────────────┬────────────╮
//   [Gas]    │ getFacets          │ empty      │    764 gas │
//   [Gas]    │                    │ 1          │  1,522 gas │
//   [Gas]    │                    │ 2          │  2,280 gas │
//   [Gas]    │                    │ 5          │  4,554 gas │
//   [Gas]    ├────────────────────┼────────────┼────────────┤
//   [Gas]    │ getFacetEntries    │ empty      │    795 gas │
//   [Gas]    │                    │ 1          │  1,974 gas │
//   [Gas]    │                    │ 2          │  3,153 gas │
//   [Gas]    │                    │ 5          │  6,693 gas │
//   [Gas]    ├────────────────────┼────────────┼────────────┤
//   [Gas]    │ getFacetAt         │ set        │    494 gas │
//   [Gas]    │                    │ free       │    494 gas │
//   [Gas]    ├────────────────────┼────────────┼────────────┤
//   [Gas]    │ getFacetCount      │ empty      │    357 gas │
//   [Gas]    │                    │ sparse (4) │    713 gas │
//   [Gas]    │                    │ full       │ 23,052 gas │
//   [Gas]    ├────────────────────┼────────────┼────────────┤
//   [Gas]    │ getFirstFreeSlot   │ 0          │    471 gas │
//   [Gas]    │                    │ 64         │    522 gas │
//   [Gas]    │                    │ 128        │    555 gas │
//   [Gas]    │                    │ 255        │    569 gas │
//   [Gas]    ├────────────────────┼────────────┼────────────┤
//   [Gas]    │ supportsInterface  │ set        │    359 gas │
//   [Gas]    │                    │ free       │    359 gas │
//   [Gas]    ╰────────────────────┴────────────┴────────────╯