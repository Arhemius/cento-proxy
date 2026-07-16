// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { bitmap256 } from "cento/types/bitmap256.sol";

/// -----------------------------------------------------------------------
/// IMPORTANT
///
/// This storage layout intentionally duplicates LibCento.CentoStorage.
///
/// DO NOT update this struct automatically.
///
/// If LibCento storage changes, tests MUST fail until this mirror is
/// explicitly reviewed and updated.
///
/// This duplication is intentional and serves as a storage-layout oracle.
/// -----------------------------------------------------------------------

struct CentoStorage {
    address[256] facets;
    bitmap256 indexBitmap;
    address contractOwner;
    mapping(bytes4 => bool) supportedInterfaces;
}