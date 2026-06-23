// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {LibCentoTest} from "./Base.t.sol";
import {Facet} from "src/structs/Facet.sol";
import {bitmap256} from "src/libraries/LibBitmap.sol";
import {ErrorAssertions} from "support/helpers/ErrorAssertions.sol";
import {EventBuilders} from "./EventBuilders.sol";
import {ErrorBuilders} from "./ErrorBuilders.sol";

abstract contract LibCentoAssert is LibCentoTest, ErrorAssertions, EventBuilders, ErrorBuilders {

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
        for (uint256 i; i < 256; ++i) {
            if (_unsafeToUint8(i) == index) continue;
            assertEq(h.facetAt(_unsafeToUint8(i)), address(0));
        }
    }

    function then_FacetsAt(Facet[] memory facets) internal view {
        for (uint256 i; i < facets.length; ++i) {
            then_FacetAt(facets[i].index, facets[i].facet);
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
        for (uint256 i; i<interfaceIds.length; ++i) {
            then_InterfaceSupported(interfaceIds[i]);
        }
    }

    function then_InterfacesNotSupported(bytes4[] memory interfaceIds) internal view {
        for (uint256 i; i<interfaceIds.length; ++i) {
            then_InterfaceNotSupported(interfaceIds[i]);
        }
    }

    // =============================================================
    // Storage — Owner
    // =============================================================

    function then_OwnerIs(address expected) internal view {
        assertEq(h.getContractOwner(), expected);
    }

    // =============================================================
    // Storage - Bitmap
    // =============================================================

    function then_StorageBitmap_Is(bitmap256 expected) internal view {
        then_BitmapIs(h.bitmap(), expected);
    }

    // =============================================================
    // Cento-Structure Invariants (CSI)
    // =============================================================

    function then_FacetBitmapCSI_Holds(bitmap256 bitmap) internal view {
        for (uint256 i; i < 256; ++i) {
            bool occupied = bitmap.isSlotOccupied(_unsafeToUint8(i));
            bool facetExists = (h.facetAt(_unsafeToUint8(i)) != address(0));
            if (occupied != facetExists) {
                revert (string.concat("FacetBitmapCSI mismatch at index", vm.toString(i)));
            }
        }
    }

    function then_ValueIs(uint256 actual, uint256 expected) internal pure {
        assertEq(actual, expected);
    }
}