// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {bitmap256, u, w} from "src/cento/libraries/LibBitmap.sol";
import {LibCento} from "src/cento/libraries/LibCento.sol";

abstract contract CentoArrange is Test {

    uint256 internal constant CS_FACETS      = uint256(LibCento.BASE_SLOT);
    uint256 internal constant CS_BITMAP      = uint256(LibCento.BASE_SLOT) + 256;
    uint256 internal constant CS_OWNER       = uint256(LibCento.BASE_SLOT) + 257;
    uint256 internal constant CS_INTERFACES  = uint256(LibCento.BASE_SLOT) + 258;

    function store_FacetAt(address target, uint8 index, address facet) internal {
        vm.store(target, 
            bytes32(CS_FACETS + index), 
            bytes32(uint256(uint160(facet)))
        );
        bitmap256 bitmap = w(uint256(vm.load(target, 
            bytes32(CS_BITMAP)
        )));
        if (facet == address(0)) bitmap = bitmap.clearSlotAt(index);
        else bitmap = bitmap.fillSlotAt(index);
        vm.store(target, 
            bytes32(CS_BITMAP), 
            bytes32(u(bitmap))
        );
    }

    function store_Owner(address target, address owner) internal {
        vm.store(target, 
            bytes32(CS_OWNER), 
            bytes32(uint256(uint160(owner)))
        );
    }

    function store_Interface(address target, bytes4 interfaceId) internal {
        vm.store(target, 
            keccak256(abi.encode(interfaceId, CS_INTERFACES)), 
            bytes32(uint256(1))
        );
    }

    // ============================================================
    // Facet helpers
    // ============================================================

    /// @dev Fills facet slots from 0 (inclusive) to `count` (exclusive).
    function store_Facets(address target, uint8 count, address facet) internal {
        for (uint8 i; i < count; i++) {
            store_FacetAt(target, i, facet);
        }
    }

    /// @dev Fills only the specified indices.
    function store_FacetsAt(address target, uint8[] memory indices, address facet) internal {
        for (uint256 i; i < indices.length; i++) {
            store_FacetAt(target, indices[i], facet);
        }
    }

    /// @dev Fills every slot except `freeIndex`.
    function store_AllExcept(address target, uint8 freeIndex, address facet) internal {
        for (uint16 i; i < 256; i++) {
            if (i != freeIndex) {                                                   // forge-lint: disable-next-line(unsafe-typecast)
                store_FacetAt(target, uint8(i), facet);
            }
        }
    }
}