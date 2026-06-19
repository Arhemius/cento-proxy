// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { bitmap256 } from "../libraries/LibBitmap.sol";

struct CentoStorage {
    address[256] facets;
    bitmap256 indexBitmap;
    address contractOwner;
    mapping(bytes4 => bool) supportedInterfaces;
}