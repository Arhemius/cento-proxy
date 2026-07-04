// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facets} from "support/fixtures/Facets.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {Interfaces} from "support/fixtures/Interfaces.sol";
import {MigratorFactory} from "support/fixtures/Migrator.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";
import {FacetManagerAct} from "./Act.sol";
import {EventBuilders} from "./EventBuilders.sol";

abstract contract FacetManagerTestSetup is 
    FacetManagerAct,
    EventBuilders,
    SimpleActors, 
    Facets, 
    Interfaces, 
    MigratorFactory {

    function lc_create() internal virtual override {
        fm = new FacetManagerAdapter();
        target(address(fm));
    }

}