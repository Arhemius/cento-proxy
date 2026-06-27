// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Cento, $CentoProxy} from "../Cento.sol";
import {CentoCall} from "../_CentoCall.sol";
import {Facet} from "src/structs/Facet.sol";
import {IFacetManager} from "src/interfaces/IFacetManager.sol";

library FacetManager {

    function atomicUpdate(
        $CentoProxy proxy,
        Facet[] memory toUpdate, 
        bytes4[] memory addI, 
        bytes4[] memory removeI,
        address migrator, 
        bytes memory _calldata
    ) internal {
        bytes memory __calldata = CentoCall._append(Cento.FACET_MANAGER,
            abi.encodeCall(IFacetManager.atomicUpdate, (toUpdate, addI, removeI, migrator, _calldata))
        );
        CentoCall._call($CentoProxy.unwrap(proxy), __calldata);
    }
    
}