// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTest} from "./Base.t.sol";
import {bitmap256} from "src/libraries/LibBitmap.sol";
import {ErrorAssertions} from "support/helpers/ErrorAssertions.sol";
import {EventBuilders} from "./Builders.sol";

abstract contract LibCentoAssert is LibCentoTest, ErrorAssertions, EventBuilders {

    // =============================================================
    // Storage — Facets
    // =============================================================

    function then_FacetAt(uint8 index, address expected) internal view {
        assertEq(h.facetAt(index), expected);
    }

    function then_FacetIsZero(uint8 index) internal view {
        assertEq(h.facetAt(index), address(0));
    }

    function then_AllFacetsZeroExcept(uint8 index) internal view {
        for (uint8 i; i < 256; ++i) {
            if (i == index) continue;
            assertEq(h.facetAt(i), address(0));
        }
    }

    // =============================================================
    // Storage — Interfaces
    // =============================================================

    function then_InterfaceSupported(bytes4 interfaceId) internal view {
        assertTrue(h.supportsInterface(interfaceId));
    }

    function then_InterfaceNotSupported(bytes4 interfaceId) internal view {
        assertFalse(h.supportsInterface(interfaceId));
    }

    function then_InterfacesSupported(bytes4[] memory interfaceIds) internal view {
        for (uint256 i; i<interfaceIds.length; ++i){
            then_InterfaceSupported(interfaceIds[i]);
        }
    }

    function then_InterfacesNotSupported(bytes4[] memory interfaceIds) internal view {
        for (uint256 i; i<interfaceIds.length; ++i){
            then_InterfaceNotSupported(interfaceIds[i]);
        }
    }

    // =============================================================
    // Storage — Owner
    // =============================================================

    function then_OwnerIs(address expected) internal view {
        assertEq(h.getContractOwner(), expected);
    }

    function then_OwnerIsZero() internal view {
        assertEq(h.getContractOwner(), address(0));
    }

    // =============================================================
    // Storage - Bitmap
    // =============================================================

    function then_StorageBitmap_Is(bitmap256 expected) internal view {
        then_BitmapIs(h.bitmap(), expected);
    }

    function then_StorageBitmap_SlotOccupied(uint8 index) internal view {
        then_SlotOccupied(h.bitmap(), index);
    }

    function then_StorageBitmap_SlotEmpty(uint8 index) internal view {
        then_SlotEmpty(h.bitmap(), index);
    }

    function then_StorageBitmap_Empty() internal view {
        then_BitmapEmpty(h.bitmap());
    }

    function then_StorageBitmap_Full() internal view {
        then_BitmapFull(h.bitmap());
    }

    // =============================================================
    // Cento-Structure Invariants (CSI)
    // =============================================================

    function then_FacetBitmapCSI_Holds() internal view {
        for (uint8 i; i < 256; ++i) {
            bool occupied = h.bitmap().isSlotOccupied(i);
            bool facetExists = (h.facetAt(i) != address(0));
            assertEq(occupied, facetExists, string.concat("FacetBitmapCSI mismatch at index", vm.toString(i)));
        }
    }
}