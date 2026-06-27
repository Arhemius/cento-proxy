// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facets} from "support/fixtures/Facets.sol";
import {Interfaces} from "support/fixtures/Interfaces.sol";
import {ObservabilityAdapter} from "support/adapters/ObservabilityAdapter.sol";
import {ObservabilityAct} from "./Act.sol";

abstract contract ObservabilityTestSetup is Facets, Interfaces, ObservabilityAct {

    function lc_create() internal virtual override {
        o = new ObservabilityAdapter();
        target(address(o));
    }

}