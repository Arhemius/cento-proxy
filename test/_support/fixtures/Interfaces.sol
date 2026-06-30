// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "support/etl/BytesNArray/Bytes4Array.sol";
import {ILibCento} from "support/interfaces/ILibCento.sol";
import {IBitmap} from "support/interfaces/IBitmap.sol";
import {IERC165} from "cento/interfaces/IERC165.sol";
import {IERC173} from "cento/interfaces/IERC173.sol";
import {IFacetManager} from "cento/interfaces/IFacetManager.sol";
import {IObservability} from "cento/interfaces/IObservability.sol";

abstract contract Interfaces {

    bytes4 internal constant i1  = bytes4(keccak256("custom.interface"));
    bytes4 internal constant i2  = type(ILibCento).interfaceId;
    bytes4 internal constant i3  = type(IBitmap).interfaceId;
    bytes4 internal constant i4  = type(IERC165).interfaceId;
    bytes4 internal constant i5  = type(IERC173).interfaceId;
    bytes4 internal constant i6  = type(IFacetManager).interfaceId;
    bytes4 internal constant i7  = type(IObservability).interfaceId;

    bytes4[6] internal _interfaces = [i2, i3, i4, i5, i6, i7];

    function interfaces() internal view returns (bytes4[] memory out) {
        out = new bytes4[](_interfaces.length);
        for (uint256 i; i < _interfaces.length; ++i) {
            out[i] = _interfaces[i];
        }
    }
}