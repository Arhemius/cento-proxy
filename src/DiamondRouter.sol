// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IObservability } from "./interfaces/IObservability.sol";
import { IFacetManager } from "./interfaces/IFacetManager.sol";
import { DiamondLib } from "./libraries/DiamondLib.sol";
import { IERC173 } from "./interfaces/IERC173.sol";
import { IERC165 } from "./interfaces/IERC165.sol";
import { Facet } from "./structs/Facet.sol";

contract DiamondRouter { 

    bytes32 constant FACET_START = 0x9470400c7fdb8128f3aa363e8652b960f10660822a80861e4d57916224d30600;

    constructor (address _contractOwner, address[3] memory facetAddresses) {
        
        DiamondLib.setContractOwner(_contractOwner);

        address[] memory facets = new address[](3);
        facets[0] = facetAddresses[0];
        facets[1] = facetAddresses[1];
        facets[2] = facetAddresses[2];

        bytes4[] memory addInterfaces = new bytes4[](4);
        addInterfaces[0] = type(IERC165).interfaceId;
        addInterfaces[1] = type(IERC173).interfaceId;
        addInterfaces[2] = type(IFacetManager).interfaceId;
        addInterfaces[3] = type(IObservability).interfaceId;

        DiamondLib.atomicUpdate(new uint256[](0), new Facet[](0), new Facet[](0), facets, addInterfaces, new bytes4[](0));

    }
    
    fallback() external payable { 
        assembly {
            let index := byte(0, calldataload(sub(calldatasize(), 1)))
            let facet := sload(add(FACET_START, index))
            if iszero(facet) { revert(0, 0) }
            calldatacopy(0, 0, sub(calldatasize(), 1))
            let result := delegatecall(gas(), facet, 0, sub(calldatasize(), 1), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) } 
        }
    }
}
