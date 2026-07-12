// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {CentoArrange} from "test/gas/cento/AAA/Arrange.sol";
import {Ownership} from "src/cento/facets/Ownership.sol";

contract OwnershipGasTest is GasReportLogger, CentoArrange, SimpleActors {

    Ownership internal OWN;
    address   internal own;

    function setUp() public {
        OWN = new Ownership();
        own = address(OWN);
        setWidths(18, 10, 10);
        store_Owner(own, owner);
    }

    function test_00_00_header() public view {
        table("Ownership");
    }

    function test_01_00_owner() public {
        OWN.owner();
        OWN.owner();
        th("owner");
    }

    function test_02_00_transferOwnership() public {
        vm.prank(owner);
        OWN.transferOwnership(user);
        th("transferOwnership");
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ Ownership ────────╮
//   [Gas]    │                    ├────────────┬────────────╮
//   [Gas]    │ owner              │            │    254 gas │
//   [Gas]    │ transferOwnership  │            │  6,745 gas │
//   [Gas]    ╰────────────────────┴────────────┴────────────╯