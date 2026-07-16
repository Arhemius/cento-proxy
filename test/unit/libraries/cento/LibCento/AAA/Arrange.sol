// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/builtins/Builtins.sol";
import {LibCentoTest} from "./Base.t.sol";
import {Facet} from "cento/structs/Facet.sol";

abstract contract LibCentoArrange is LibCentoTest {

    // =============================================================
    // ARRANGE — storage / state builders
    // =============================================================

    function arrange_FullFacetArray(address facet) internal {
        require(facet != address(0), "Cannot fill array with zero addresses");
        for (uint256 i; i < 256; ++i) h.setFacetAt(_unsafeToUint8(i), facet);
        h.setBitmap(FULL_BITMAP);
    }

    function arrange_FacetAt(uint8 index, address facet) internal {
        require(facet != address(0), "Cannot fill array with zero addresses");
        h.setFacetAtWithBitmap(index, facet);
    }

    function arrange_FacetsAt(Facet[] memory facets) internal {
        for (uint256 i; i < facets.length; ++i) {
            arrange_FacetAt(facets[i].index, facets[i].facet);
        }
    }

    function arrange_Owner(address owner_) internal {
        h.setOwner(owner_);
    }

    function arrange_Interface(bytes4 interfaceId) internal {
        h.setInterface(interfaceId, true);
    }

    function arrange_Interfaces(bytes4[] memory ids) internal {
        for (uint256 i; i < ids.length; ++i) {
            h.setInterface(ids[i], true);
        }
    }

    // =============================================================
    // GIVEN — pure value generators
    // =============================================================

    function given_EmptyFacetArray() internal pure returns (Facet_[] memory) {
        return new Facet_[](0);
    }

    function given_FacetAt(uint8 index, address facet) internal pure returns (Facet memory) {
        return Facet({index: index, facet: facet});
    }

    function given_MigratorCall(bytes4 selector, bytes memory args) internal pure returns (bytes memory data) {
        return abi.encodeWithSelector(selector, args);
    }

    function given_MigratorCall(bytes4 selector) internal pure returns (bytes memory data) {
        return abi.encodeWithSelector(selector);
    }
}