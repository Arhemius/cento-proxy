// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {DiamondTM} from "../../_diamond-2/AAA/_DiamondTM.sol";
import {Diamond} from "../../_diamond-2/src/Diamond.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {IDiamondLoupe} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondLoupe.sol";
import {DiamondInit} from "test/gas/cento/_diamond-2/src/upgradeInitializers/DiamondInit.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {Dummies} from "support/fixtures/dummies/Dummies.sol";

contract DiamondCutGasTest is DiamondTM, Dummies, SimpleActors, GasReportLogger {

    function _create() internal override {
        Diamond diamond = new Diamond(owner, diamondCut);
        target(address(diamond));
        vm.prank(owner);
        (bool ok,) = address(diamond).call(abi.encodeCall(
            IDiamondCut.diamondCut, (DiamondDeploymentCut, diamondInit, abi.encodeCall(DiamondInit.init, ()))
        ));
        if (!ok) revert("create: diamondCut failed (diamond)");
    }

    function _bootstrap() internal override {
        installAndInit(Add5Cuts, NO_ADDRESS(), NO_DATA());
    }

    function _setup() internal override {
        setWidths(26, 10, 11);
        vm.startPrank(owner);
    }

    function test_00_00_header() public view {
        table("Facets (Diamond)");
    }

    function test_01_00_facets_baseline() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Rem5Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        th("facets", "baseline");
    }

    function test_01_01_facets_4() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Rem4Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        tr("facets", "4 facets");
    }

    function test_01_02_facets_5() public {
        (bool ok,) = diamond.call(abi.encodeCall(
            IDiamondCut.diamondCut, (Rem3Cuts, NO_ADDRESS(), NO_DATA())
        ));
        if (!ok) revert("diamondCut failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        tr("facets", "5 facets");
    }

    function test_01_03_facets_8() public {
        (bool ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        (ok,) = diamond.call(abi.encodeCall(IDiamondLoupe.facets, ()));
        if (!ok) revert("facets failed");
        tr("facets", "8 facets");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   ======== Isolation mode ========

//   [Gas]    ╭─ Facets (Diamond) ─────────╮
//   [Gas]    │                            ├────────────┬─────────────╮
//   [Gas]    │ facets                     │ baseline   │  63,580 gas │
//   [Gas]    │                            │ 4 facets   │ 114,210 gas │
//   [Gas]    │                            │ 5 facets   │ 164,833 gas │
//   [Gas]    │                            │ 8 facets   │ 333,994 gas │
//   [Gas]    ╰────────────────────────────┴────────────┴─────────────╯