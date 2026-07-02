// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV1, $CentoProxyV1} from "../../CentoV1.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {Facet} from "cento/structs/Facet.sol";
import {IFacetManager} from "cento/interfaces/IFacetManager.sol";

library FacetManager {

    function atomicUpdate(
        $CentoProxyV1 proxy,
        Facet[] memory toUpdate, 
        bytes4[] memory addI, 
        bytes4[] memory removeI,
        address migrator, 
        bytes memory _calldata
    ) internal {
        bytes memory __calldata = CentoCall._append(CentoV1.FACET_MANAGER,
            abi.encodeCall(IFacetManager.atomicUpdate, (toUpdate, addI, removeI, migrator, _calldata))
        );
        CentoCall._call($CentoProxyV1.unwrap(proxy), __calldata);
    }
    
}