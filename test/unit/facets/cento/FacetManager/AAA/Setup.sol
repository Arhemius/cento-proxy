// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facets} from "support/fixtures/Facets.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";
import {FacetManagerAct} from "./Act.sol";

abstract contract FacetManagerTestSetup is FacetManagerAct, SimpleActors, Facets {

    function lc_create() internal virtual override {
        fm = new FacetManagerAdapter();
        target(address(fm));
    }

}