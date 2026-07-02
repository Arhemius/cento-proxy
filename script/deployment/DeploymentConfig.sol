// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {CentoV1} from "interaction/CentoV1.sol";
import {CounterV1} from "src/protocol/v1/CounterV1.sol";

abstract contract DeploymentConfig {

    function buildDeployment() internal virtual returns (
        Facet[] memory setFacets,
        bytes4[] memory addInterfaces,
        address migrator,
        bytes memory migratorCalldata
    ) {
        setFacets = FacetArr(abi.encode(
            CentoV1.COUNTER_V1, address(new CounterV1())
        ))._out();

        addInterfaces = new bytes4[](0);
        migrator = address(0);
        migratorCalldata = "";
    }
}