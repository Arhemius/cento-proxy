// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Facet} from "cento/structs/Facet.sol";
import {ObservabilityTest} from "./Base.t.sol";

abstract contract ObservabilityAct is ObservabilityTest {

    // cannot emit error because contract must have at least 1 facet occupied as observability
    function when_GetFacets() internal view returns (address[] memory result) {
        result = oa.getFacets();
    }

    function when_GetFacetEntries() internal view returns (Facet[] memory result) {
        result = oa.getFacetEntries();
    }

    function when_GetFacetAt(uint8 index) internal view returns (address facet) {
        facet = oa.getFacetAt(index);
    }

    function when_GetFacetCount() internal view returns (uint16 count) {
        count = oa.getFacetCount();
    }

    // getFirstFreeSlot may return an error NoFreeSlots
    function when_GetFirstFreeSlot(uint8 config) internal returns (uint8 index) {
        if (Errors(config)) {
            Execute(address(oa), abi.encodeWithSelector(oa.getFirstFreeSlot.selector));
        } else {
            index = oa.getFirstFreeSlot();
        }
    }

    function when_SupportsInterface(bytes4 _interfaceId) internal view returns (bool) {
        return oa.supportsInterface(_interfaceId);
    }
    
}