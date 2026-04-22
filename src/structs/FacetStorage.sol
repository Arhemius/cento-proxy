// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

struct FacetStorage {
    address[] facets;
    uint256[] emptySlots;
    address contractOwner;
    mapping(bytes4 => bool) supportedInterfaces;
}