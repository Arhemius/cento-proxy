// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {SimpleActors} from "support/actors/SimpleActors.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {CentoTM} from "support/setup/v1/_CentoTM.sol";
import {Facets} from "support/fixtures/Facets.sol";
import {Interfaces} from "support/fixtures/Interfaces.sol";

abstract contract CentoTestSetup is CentoTM, SimpleActors, Facets, Interfaces {

    function _create() internal virtual override {
        super._create();
        CentoRouter cento = new CentoRouter(
            owner, [facetManager, ownership, observability]
        );
        target(address(cento));
    }
}