// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {LibCento} from "src/cento/libraries/LibCento.sol";

abstract contract CentoArrange is Test {

    function store_FacetAt(address target, uint8 index, address facet) internal {
        vm.store(target, 
            bytes32(uint256(LibCento.BASE_SLOT) + index), 
            bytes32(uint256(uint160(facet)))
        );
    }

    function store_Owner(address target, address owner) internal {
        vm.store(target, 
            bytes32(uint256(LibCento.BASE_SLOT) + 257), 
            bytes32(uint256(uint160(owner)))
        );
    }

    function store_Interface(address target, bytes4 interfaceId) internal {
        vm.store(target, 
            keccak256(abi.encode(interfaceId, uint256(LibCento.BASE_SLOT) + 258)), 
            bytes32(uint256(1))
        );
    }
}