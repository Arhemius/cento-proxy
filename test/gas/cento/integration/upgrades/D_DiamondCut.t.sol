// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {DiamondTM} from "../../_diamond-2/AAA/_DiamondTM.sol";
import {Diamond} from "../../_diamond-2/src/Diamond.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {DiamondInit} from "test/gas/cento/_diamond-2/src/upgradeInitializers/DiamondInit.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {Dummies} from "support/fixtures/dummies/Dummies.sol";

contract DiamondCutGasTest is DiamondTM, Dummies, SimpleActors, GasReportLogger {

    address internal diamondAdd;

    function _create() internal override {
        Diamond diamond = new Diamond(owner, diamondCut);
        target(address(diamond));
        vm.prank(owner);
        (bool ok,) = address(diamond).call(abi.encodeCall(
            IDiamondCut.diamondCut, (DiamondDeploymentCut, diamondInit, abi.encodeCall(DiamondInit.init, ()))
        ));
        if (!ok) revert("create: diamondCut failed (diamond)");

        diamondAdd = address(new Diamond(owner, diamondCut));
        vm.prank(owner);
        (ok,) = diamondAdd.call(abi.encodeCall(
            IDiamondCut.diamondCut, (DiamondDeploymentCut, diamondInit, abi.encodeCall(DiamondInit.init, ()))
        ));
        if (!ok) revert("create: diamondCut failed (diamondAdd)");
    }

    function _bootstrap() internal override {
        installAndInit(Add5Cuts, NO_ADDRESS(), NO_DATA());
    }

    function _setup() internal override {
        setWidths(22, 10, 13);
        vm.startPrank(owner);
    }

    function test_00_00_header() public view {
        table("DiamondCut (Diamond)");
    }

    // ========== Add Facets ==========

    function test_01_00_addCuts_1() public {
        (bool ok,) = diamondAdd.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Add1Cut, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        th("diamondCut", "addF (1)");
    }

    function test_01_01_addCuts_2() public {
        (bool ok,) = diamondAdd.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Add2Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        tr("diamondCut", "addF (2)");
    }

    function test_01_02_addCuts_5() public {
        (bool ok,) = diamondAdd.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Add5Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        tr("diamondCut", "addF (5)");
        hr();
    }

    // ========== Update Facets ==========

    function test_02_00_updCuts_1() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Upd1Cut, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        th("diamondCut", "updF (1)");
    }

    function test_02_01_updCuts_2() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Upd2Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        tr("diamondCut", "updF (2)");
    }

    function test_02_02_updCuts_5() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Upd5Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        tr("diamondCut", "updF (5)");
        hr();
    }

    // ========== Remove Facets ==========

    function test_03_00_remCuts_1() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Rem1Cut, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        th("diamondCut", "remF (1)");
    }

    function test_03_01_remCuts_2() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Rem2Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        tr("diamondCut", "remF (2)");
    }

    function test_03_02_remCuts_5() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Rem5Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        tr("diamondCut", "remF (5)");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   ======== Isolation mode (the only reliable mode for measurement, despite overhead) ========

//   [Gas]    ╭─ DiamondCut (Diamond) ─╮
//   [Gas]    │                        ├────────────┬───────────────╮
//   [Gas]    │ diamondCut             │ addF (1)   │   321,168 gas │
//   [Gas]    │                        │ addF (2)   │   582,877 gas │
//   [Gas]    │                        │ addF (5)   │ 1,390,250 gas │
//   [Gas]    ├────────────────────────┼────────────┼───────────────┤
//   [Gas]    │ diamondCut             │ updF (1)   │   104,956 gas │
//   [Gas]    │                        │ updF (2)   │   173,295 gas │
//   [Gas]    │                        │ updF (5)   │   378,380 gas │
//   [Gas]    ├────────────────────────┼────────────┼───────────────┤
//   [Gas]    │ diamondCut             │ remF (1)   │   143,107 gas │
//   [Gas]    │                        │ remF (2)   │   250,266 gas │
//   [Gas]    │                        │ remF (5)   │   341,986 gas │
//   [Gas]    ╰────────────────────────┴────────────┴───────────────╯