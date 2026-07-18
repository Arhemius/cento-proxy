// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoTM} from "support/setup/v1/_CentoTM.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {Ownership} from "src/cento/facets/Ownership.sol";
import {CentoCall} from "interaction/_CentoCall.sol";
import {CentoV1} from "interaction/CentoV1.sol";
import {IERC173} from "cento/interfaces/IERC173.sol";
import {PureRouterAdapter} from "support/adapters/PureRouterAdapter.sol";
import {AppendRouterAdapter} from "support/adapters/AppendRouterAdapter.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CentoArrange} from "test/gas/cento/AAA/Arrange.sol";

contract CentoRouterGasTest is CentoTM, GasReportLogger, SimpleActors, CentoArrange {

    PureRouterAdapter   private pr;
    AppendRouterAdapter private ar;

    uint256 private directCallGasOverhead;
    uint256 private adapterGasOverhead;
    uint256 private totalGasOverhead;

    function _create() internal override {
        super._create();
        bool ok;
        CentoRouter cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );
        vm.store(ownership, bytes32(CS_OWNER), bytes32(uint256(uint160(owner))));
        bytes memory _calldata = abi.encodeCall(IERC173.owner, ());
        (ok,) = ownership.staticcall(_calldata);
        if (!ok) revert("setUp: first staticcall failed");
        directCallGasOverhead = vm.snapshotGasLastCall("__");

        ownership = address(new Ownership());
        cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        ); 
        CentoCall._append(CentoV1.OWNERSHIP, _calldata);
        (ok,) = address(cento).staticcall(_calldata);
        if (!ok) revert("setUp: second staticcall failed");
        uint256 routerGasOverhead = vm.snapshotGasLastCall("__") - directCallGasOverhead;

        ownership = address(new Ownership());
        cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );
        pr = new PureRouterAdapter(address(cento));
        ar = new AppendRouterAdapter(address(cento));
        pr.owner(_calldata);
        adapterGasOverhead = vm.snapshotGasLastCall("__") - (directCallGasOverhead + routerGasOverhead);
        totalGasOverhead = adapterGasOverhead + directCallGasOverhead;

        setWidths(16, 9, 9);
    }

    function test_00_00_header() public view {
        table("Cento Router");
    }

    function test_01_00_cento_pure() public {
        bytes memory _calldata = abi.encodeCall(IERC173.owner, ());
        CentoCall._append(CentoV1.OWNERSHIP, _calldata);
        pr.owner(_calldata);
        pr.owner(_calldata);
        th("cento", "pure", vm.snapshotGasLastCall("cento", "pure") - totalGasOverhead);
    }

    function test_01_01_cento_append() public {
        bytes memory _calldata = abi.encodeCall(IERC173.owner, ());
        ar.owner(_calldata);
        ar.owner(_calldata);
        tr("cento", "append", vm.snapshotGasLastCall("cento", "append") - totalGasOverhead);
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   ======== Isolation mode ========

//   [Gas]    ╭─ Cento Router ───╮
//   [Gas]    │                  ├───────────┬───────────╮
//   [Gas]    │ cento            │ pure      │ 4,873 gas │
//   [Gas]    │                  │ append    │ 4,909 gas │
//   [Gas]    ╰──────────────────┴───────────┴───────────╯