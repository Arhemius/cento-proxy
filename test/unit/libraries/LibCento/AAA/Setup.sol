// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoAct} from "./Act.sol";
import {LibCentoTM} from "./_LibCentoTM.sol";
import {Facets} from "support/fixtures/Facets.sol";
import {Interfaces} from "support/fixtures/Interfaces.sol";
import {EIP7702EOA} from "support/fixtures/EIP7702EOA.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {MigratorFactory} from "support/fixtures/Migrator.sol";
import {LibCentoAdapter} from "support/adapters/LibCentoAdapter.sol";

abstract contract LibCentoTestSetup is LibCentoTM, LibCentoAct, Interfaces, Facets, EIP7702EOA, SimpleActors, MigratorFactory {

    function lc_createHarnessTarget() internal override returns (address) {
        lc = new LibCentoAdapter();
        return address(lc);
    }
}