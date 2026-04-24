// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { CompatibilityStandards } from "./standards/CompatibilityStandards.sol";
import { IObservability } from "./interfaces/IObservability.sol";
import { IFacetManager } from "./interfaces/IFacetManager.sol";
import { DiamondLib } from "./libraries/DiamondLib.sol";
import { IERC173 } from "./interfaces/IERC173.sol";
import { IERC165 } from "./interfaces/IERC165.sol";
import { Facet } from "./structs/Facet.sol";

contract DiamondRouter is CompatibilityStandards { 

    constructor (address _contractOwner, address[3] memory facetAddresses) {
        DiamondLib.setContractOwner(_contractOwner);

        Facet[] memory facets = new Facet[](3);
        facets[0] = Facet({index: 0, facet: facetAddresses[0]});
        facets[1] = Facet({index: 1, facet: facetAddresses[1]});
        facets[2] = Facet({index: 2, facet: facetAddresses[2]});

        bytes4[] memory addInterfaces = new bytes4[](4);
        addInterfaces[0] = type(IERC165).interfaceId;
        addInterfaces[1] = type(IERC173).interfaceId;
        addInterfaces[2] = type(IFacetManager).interfaceId;
        addInterfaces[3] = type(IObservability).interfaceId;

        DiamondLib.atomicUpdate(facets, addInterfaces, new bytes4[](0));
    }

    function dispatch(uint8 trim) internal {
        bytes32 start = DiamondLib.BASE_SLOT;
        assembly {
            let index := byte(0, calldataload(sub(calldatasize(), 1)))
            let facet := sload(add(start, index))
            if iszero(facet) { revert(0, 0) }
            calldatacopy(0, sub(trim, 1), sub(calldatasize(), trim))
            let result := delegatecall(gas(), facet, 0, sub(calldatasize(), trim), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) } 
        }
    }

    function centoEntry() external payable {
        dispatch(5);
    }

    fallback() external payable { 
        dispatch(1);
    }

    receive() external payable {}
}
