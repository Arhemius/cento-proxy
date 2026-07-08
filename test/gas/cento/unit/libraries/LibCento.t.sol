// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {LibCentoTM} from "test/unit/libraries/cento/LibCento/AAA/_LibCentoTM.sol";
import {LibCentoDebugAdapter} from "support/adapters/LibCentoDebugAdapter.sol";
import {MigratorFactory} from "support/fixtures/Migrator.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {Facets as _Facets} from "support/fixtures/Facets.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CentoArrange} from "test/gas/cento/AAA/Arrange.sol";

contract LibCentoGasTest is LibCentoTM, CentoArrange, _Facets, SimpleActors, MigratorFactory, GasReportLogger {

    LibCentoDebugAdapter internal rc;
    address internal rc_;

    function lc_create() internal override {
        rc = new LibCentoDebugAdapter();
        rc_ = address(rc);
        setWidths(22, 10, 10);
    }

    function test_00_00_header() public view {
        table("LibCento");
    }

    // ========== setFacet ==========
    function test_01_00_setFacet_Add() public {
        rc.setFacet(42, facetA, given_SingleBit(42));
        th("setFacet", "add");
    }

    function test_01_01_setFacet_Update() public {
        store_FacetAt(rc_, 42, facetB);
        rc.setFacet(42, facetA, given_SingleBit(42));
        tr("setFacet", "update");
    }

    function test_01_02_setFacet_Remove() public {
        store_FacetAt(rc_, 42, facetB);
        rc.setFacet(42, address(0), given_SingleBit(42));
        tr("setFacet", "remove");
        hr();
    }

    // ========== ownership ==========
    function test_02_00_contractOwner() public {
        rc.setContractOwner(owner);
        rc.contractOwner();
        th("contractOwner");
    }

    function test_03_00_enforceIsContractOwner() public {
        rc.setContractOwner(owner);
        vm.prank(owner);
        rc.enforceIsContractOwner();
        th("enforceIsContractOwner");
    }

    function test_04_00_setContractOwner() public {
        rc.setContractOwner(owner);
        th("setContractOwner");
        hr();
    }

    // ========== storageMigration ==========
    function test_05_00_storageMigration_Call() public {
        rc.storageMigration(migrator, abi.encodeCall(Migrator.dummy, ()));
        th("storageMigration", "call");
    }
    
    function test_05_01_storageMigration_Skip() public {
        rc.storageMigration(address(0), "");
        tr("storageMigration", "skip");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ LibCento ─────────────╮
//   [Gas]    │                        ├────────────┬────────────╮
//   [Gas]    │ setFacet               │ add        │ 25,393 gas │
//   [Gas]    │                        │ update     │  3,493 gas │
//   [Gas]    │                        │ remove     │    716 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ contractOwner          │            │    310 gas │
//   [Gas]    │ enforceIsContractOwner │            │    326 gas │
//   [Gas]    │ setContractOwner       │            │ 23,879 gas │
//   [Gas]    ├────────────────────────┼────────────┼────────────┤
//   [Gas]    │ storageMigration       │ call       │  5,115 gas │
//   [Gas]    │                        │ skip       │    616 gas │
//   [Gas]    ╰────────────────────────┴────────────┴────────────╯