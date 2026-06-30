// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facet} from "cento/structs/Facet.sol";
import {FacetManagerTest} from "./Base.t.sol";

abstract contract FacetManagerAct is FacetManagerTest {

    function when_AtomicUpdate(
        uint8 config,
        Facet[] memory setF,
        bytes4[] memory addI, bytes4[] memory remI,
        address migrator_, bytes memory data
    ) internal {
        if (Errors(config)) {
            Execute(address(fm), abi.encodeWithSelector(fm.atomicUpdate.selector, 
                setF, addI, remI, migrator_, data
            ));
        } else {
            fm.atomicUpdate(setF, addI, remI, migrator_, data);
        }
    }
}