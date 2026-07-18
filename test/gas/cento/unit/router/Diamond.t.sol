// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {DiamondTM} from "../../_diamond-2/AAA/_DiamondTM.sol";
import {Diamond} from "../../_diamond-2/src/Diamond.sol";
import {IERC173} from "../../_diamond-2/src/interfaces/IERC173.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {DiamondInit} from "test/gas/cento/_diamond-2/src/upgradeInitializers/DiamondInit.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {LibDiamond} from "../../_diamond-2/src/libraries/LibDiamond.sol";

contract DiamondGasTest is DiamondTM, GasReportLogger, SimpleActors {

    uint256 private directCallGasOverhead;

    function _create() internal override {
        bool ok; bytes memory ret;
        Diamond diamond = new Diamond(owner, diamondCut);
        target(address(diamond));
        vm.prank(owner);
        (ok,) = address(diamond).call(abi.encodeCall(
            IDiamondCut.diamondCut, (DiamondDeploymentCut, diamondInit, abi.encodeCall(DiamondInit.init, ()))
        ));
        if (!ok) revert("install: diamondCut failed");
        vm.store(ownership, 
            bytes32(uint256(LibDiamond.DIAMOND_STORAGE_POSITION) + 4), 
            bytes32(uint256(uint160(owner))));
        bytes memory _calldata = abi.encodeCall(IERC173.owner, ());
        (ok, ret) = ownership.staticcall(_calldata);
        if (!ok) revert("setUp: first staticcall failed");
        directCallGasOverhead = vm.snapshotGasLastCall("__");

        setWidths(16, 9, 9);
    }
        
    function test_00_00_header() public view {
        table("Diamond Router");
    }

    function test_01_00_diamond() public {
        bytes memory _calldata = abi.encodeCall(IERC173.owner, ());
        (bool ok,) = diamond.staticcall(_calldata);
        if (!ok) revert("diamond: owner query failed");
        (ok,) = diamond.staticcall(_calldata);
        if (!ok) revert("diamond: owner query failed");
        th("diamond", vm.snapshotGasLastCall("diamond") - directCallGasOverhead);
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   ======== Isolation mode ========

//   [Gas]    ╭─ Diamond Router ─╮
//   [Gas]    │                  ├───────────┬───────────╮
//   [Gas]    │ diamond          │           │ 4,898 gas │
//   [Gas]    ╰──────────────────┴───────────┴───────────╯