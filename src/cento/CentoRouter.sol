// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IObservability } from "./interfaces/IObservability.sol";
import { IFacetManager } from "./interfaces/IFacetManager.sol";
import { LibCento as lc } from "./libraries/LibCento.sol";
import { IERC173 } from "./interfaces/IERC173.sol";
import { IERC165 } from "./interfaces/IERC165.sol";
import { CentoStorage as CS } from "./structs/CentoStorage.sol";
import { w } from "./libraries/LibBitmap.sol";

contract CentoRouter { 
    /// @dev error FacetNotFound(uint8 index)
    bytes4  private constant ERR_FACET_NOT_FOUND = 0xca05c783;
    bytes32 private constant BASE_SLOT    = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;
    uint8   private constant ERC173_INDEX = 1;
    uint8   private constant ERC165_INDEX = 2;

    constructor (address _contractOwner, address[3] memory facetAddresses) {
        CS storage cs = lc._cs();
        cs.contractOwner = _contractOwner; 
        emit lc.OwnershipTransferred(address(0), _contractOwner);
        cs.facets[0] = facetAddresses[0];
        cs.facets[1] = facetAddresses[1];
        cs.facets[2] = facetAddresses[2];
        cs.indexBitmap = w(7); // 0b000000...00000111
        cs.supportedInterfaces[type(IERC165).interfaceId] = true; 
        cs.supportedInterfaces[type(IERC173).interfaceId] = true; 
        cs.supportedInterfaces[type(IFacetManager).interfaceId] = true; 
        cs.supportedInterfaces[type(IObservability).interfaceId] = true;
    }

    // TODO: Write the Stage 2 generator script
    // You will have generator script and the config where you(dev) could specify the
    // interfaces they tend to support, and add custom ones
    fallback() external payable {
        assembly {
            let cds := calldatasize()
            if and(cds, 1) {
                executeFacet(byte(0, calldataload(sub(cds, 1))), cds, 1)
            } // If you have more than 6 selectors, use optimized BST
            switch shr(224, calldataload(0))
            case 0x01ffc9a7 { executeFacet(ERC165_INDEX, cds, 0) }
            case 0x8da5cb5b { executeFacet(ERC173_INDEX, cds, 0) }
            case 0xf2fde38b { executeFacet(ERC173_INDEX, cds, 0) }
            executeFacet(byte(0, calldataload(sub(cds, 1))), cds, 1)

            /// @dev Executes a delegatecall to the resolved facet address.
            /// @param idx The index of the facet layout in storage.
            /// @param totalSize Total calldata length available.
            /// @param stripLen Bytes to strip from the end of calldata (0 or 1)
            /// @notice inline functions are impossible to cover in the eyes of forge coverage
            function executeFacet(idx, totalSize, stripLen) {
                let facet := sload(add(BASE_SLOT, idx))
                if iszero(facet) { 
                    mstore(0x00, ERR_FACET_NOT_FOUND)
                    mstore(0x04, idx)
                    revert(0x00, 0x24)
                }
                let size := sub(totalSize, stripLen)
                calldatacopy(0, 0, size)
                let ok := delegatecall(gas(), facet, 0, size, 0, 0)
                returndatacopy(0, 0, returndatasize())
                switch ok
                case 0  { revert(0, returndatasize()) }
                default { return(0, returndatasize()) }
            }
        }
    }
    
    receive() external payable {}
}
// thanks to routing strategy, facets can also implement receive functions and handle payments there

    // if lt(selector, 0x8da5cb5b) {
    //     if eq(selector, 0x01ffc9a7) { executeFacet(ERC165_INDEX, cds, 0) }
    // }
    // if eq(selector, 0x8da5cb5b) { executeFacet(ERC173_INDEX, cds, 0) }
    // if eq(selector, 0xf2fde38b) { executeFacet(ERC173_INDEX, cds, 0) }
    


// if lt(selector, 0x23b872dd) {
//     if lt(selector, 0x095ea7b3) {
//         if eq(selector, 0x01ffc9a7) { executeFacet(0, cds, 0) }
//         if eq(selector, 0x06fdde03) { executeFacet(1, cds, 0) }
//     }
//     if eq(selector, 0x095ea7b3) { executeFacet(2, cds, 0) }
//     if eq(selector, 0x18160ddd) { executeFacet(3, cds, 0) }
// }
// if lt(selector, 0x8da5cb5b) {
//     if eq(selector, 0x23b872dd) { executeFacet(4, cds, 0) }
//     if eq(selector, 0x313ce567) { executeFacet(5, cds, 0) }
// }
// if eq(selector, 0x70a08231) { executeFacet(6, cds, 0) }
// if eq(selector, 0x8da5cb5b) { executeFacet(7, cds, 0) }
// if eq(selector, 0xf2fde38b) { executeFacet(8, cds, 0) }
