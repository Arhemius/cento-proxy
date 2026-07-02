// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {CentoTM} from "support/setup/v1/_CentoTM.sol";
import {CentoV1} from "interaction/CentoV1.sol";
import "support/builtins/Builtins.sol";
import {CounterV1} from "src/protocol/v1/CounterV1.sol";

abstract contract V1TestSetup is CentoTM, SimpleActors {

    function _create() internal virtual override {
        super._create();
        CentoRouter cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );
        target(address(cento));
    }

    function _bootstrap() internal virtual override {
        CounterV1 counter1 = new CounterV1();
        install(FacetArr(abi.encode(
           CentoV1.COUNTER_V1, address(counter1)
        ))._out(), NO_INTERFACES());
    }
}