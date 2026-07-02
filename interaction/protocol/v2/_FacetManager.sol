// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV2, $CentoProxyV2} from "../../CentoV2.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {Facet} from "cento/structs/Facet.sol";
import {IFacetManager} from "cento/interfaces/IFacetManager.sol";

library FacetManager {

    function atomicUpdate(
        $CentoProxyV2 proxy,
        Facet[] memory toUpdate, 
        bytes4[] memory addI, 
        bytes4[] memory removeI,
        address migrator, 
        bytes memory _calldata
    ) internal {
        bytes memory __calldata = CentoCall._append(CentoV2.FACET_MANAGER,
            abi.encodeCall(IFacetManager.atomicUpdate, (toUpdate, addI, removeI, migrator, _calldata))
        );
        CentoCall._call($CentoProxyV2.unwrap(proxy), __calldata);
    }
    
}