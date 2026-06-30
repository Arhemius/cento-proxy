// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Facet } from "../structs/Facet.sol";

interface IObservability {

    function getFacets() external view returns (address[] memory);

    function getFacetEntries() external view returns (Facet[] memory);

    function getFacetAt(uint8 index) external view returns (address);

    function getFacetCount() external view returns (uint16);

    function getFirstFreeSlot() external view returns (uint8);
}