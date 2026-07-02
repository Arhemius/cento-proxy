// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {Facet} from "cento/structs/Facet.sol";
import {CentoV2} from "interaction/CentoV2.sol";
import {CounterV2} from "src/protocol/v2/CounterV2.sol";

abstract contract UpgradeConfig {

    function buildUpgrade() internal virtual returns (
        Facet[] memory setFacets,
        bytes4[] memory addInterfaces,
        bytes4[] memory removeInterfaces,
        address migrator,
        bytes memory migratorCalldata
    ) {
        setFacets = FacetArr(abi.encode(
            CentoV2.COUNTER_V2, address(new CounterV2())
        ))._out();

        addInterfaces = new bytes4[](0);
        removeInterfaces = new bytes4[](0);
        migrator = address(0);
        migratorCalldata = "";
    }
}