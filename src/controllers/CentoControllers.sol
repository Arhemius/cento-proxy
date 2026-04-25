// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract CentoControllers {

    bytes32 private constant BASE_SLOT = 0x69f90de95fb99742e875407e8b95a22f11141a7a0ca101bc562658f163a85b00;
    
    uint8 constant ERC165_INDEX = 0;

    function delegate(uint8 index) private {
        assembly {
            let facet := sload(add(BASE_SLOT, index))
            if iszero(facet) { revert(0, 0) }
            let size := calldatasize()
            calldatacopy(0, 0, size)
            if iszero(delegatecall(gas(), facet, 0, size, 0, 0)) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
            returndatacopy(0, 0, returndatasize())
            return(0, returndatasize())
        }
    }

    function supportsInterface(bytes4) external returns (bool) { delegate(ERC165_INDEX); }
}