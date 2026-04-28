// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import { CentoControllers } from "./controllers/CentoControllers.sol";
import { IObservability } from "./interfaces/IObservability.sol";
import { IFacetManager } from "./interfaces/IFacetManager.sol";
import { LibCento } from "./libraries/LibCento.sol";
import { IERC173 } from "./interfaces/IERC173.sol";
import { IERC165 } from "./interfaces/IERC165.sol";
import { Facet } from "./structs/Facet.sol";

contract CentoRouter is CentoControllers { 

    bytes32 private constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;

    constructor (address _contractOwner, address[3] memory facetAddresses) {
        LibCento.setContractOwner(_contractOwner);

        Facet[] memory facets = new Facet[](3);
        facets[0] = Facet({index: 0, facet: facetAddresses[0]});
        facets[1] = Facet({index: 1, facet: facetAddresses[1]});
        facets[2] = Facet({index: 2, facet: facetAddresses[2]});

        bytes4[] memory addInterfaces = new bytes4[](4);
        addInterfaces[0] = type(IERC165).interfaceId;
        addInterfaces[1] = type(IERC173).interfaceId;
        addInterfaces[2] = type(IFacetManager).interfaceId;
        addInterfaces[3] = type(IObservability).interfaceId;

        LibCento.atomicUpdate(facets, addInterfaces, new bytes4[](0));
    }

    function centoEntry() external payable {
        assembly {
            let size := calldatasize()
            let index := byte(0, calldataload(sub(size, 1)))
            let facet := sload(add(BASE_SLOT, index))
            if iszero(facet) { revert(0, 0) }
            size := sub(size, 5)
            calldatacopy(0, 4, size)
            if iszero(delegatecall(gas(), facet, 0, size, 0, 0)) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize()) 
        }
    }

    fallback() external payable { 
        assembly {
            let size := sub(calldatasize(), 1)
            let index := byte(0, calldataload(size))
            let facet := sload(add(BASE_SLOT, index))
            if iszero(facet) { revert(0, 0) }
            calldatacopy(0, 0, size)
            if iszero(delegatecall(gas(), facet, 0, size, 0, 0)) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }

    receive() external payable {}
}
