// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {CentoTM} from "support/setup/v2/_CentoTM.sol";
import {CentoV2} from "interaction/CentoV2.sol";
import "support/builtins/Builtins.sol";
import {CounterV2} from "src/protocol/v2/CounterV2.sol";

abstract contract CounterV2TestSetup is CentoTM, SimpleActors {

    address internal counterV2Facet;

    function _create() internal virtual override {
        super._create();
        CentoRouter cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );
        target(address(cento));
    }

    function _bootstrap() internal virtual override {
        CounterV2 counterV2 = new CounterV2();
        counterV2Facet = address(counterV2);
        install(FacetArr(abi.encode(
           CentoV2.COUNTER_V2, address(counterV2)
        ))._out(), NO_INTERFACES());
    }
}