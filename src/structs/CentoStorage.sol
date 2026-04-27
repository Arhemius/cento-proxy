// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

struct CentoStorage {
    address[256] facets;
    uint256 indexBitmap;
    address contractOwner;
    mapping(bytes4 => bool) supportedInterfaces;
}