// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {CentoRouterAct} from "./Act.sol";
import {CentoRouterAdapter} from "support/adapters/CentoRouterAdapters.sol";
import {FacetManagerAdapter} from "support/adapters/FacetManagerAdapter.sol";
import {OwnershipAdapter} from "support/adapters/OwnershipAdapter.sol";
import {ObservabilityAdapter} from "support/adapters/ObservabilityAdapter.sol";
import {$CentoProxyV1} from "interaction/CentoV1.sol";
import {Interfaces} from "support/fixtures/Interfaces.sol";

abstract contract CentoRouterTestSetup is CentoRouterAct, SimpleActors, Interfaces {

    function lc_create() internal virtual override {
        cr = new CentoRouterAdapter(owner, [
            address(new FacetManagerAdapter()), 
            address(new OwnershipAdapter()), 
            address(new ObservabilityAdapter()) 
        ]);
        target(address(cr));
        CentoProxy = $CentoProxyV1.wrap(address(cr));
    }

}