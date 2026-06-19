// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {ILibCento} from "support/interfaces/ILibCento.sol";
import {IBitmap} from "support/interfaces/IBitmap.sol";
import {IERC165} from "src/interfaces/IERC165.sol";
import {IERC173} from "src/interfaces/IERC173.sol";
import {IFacetManager} from "src/interfaces/IFacetManager.sol";
import {IObservability} from "src/interfaces/IObservability.sol";

abstract contract Interfaces {

    bytes4 internal constant CUSTOM_ID  = bytes4(keccak256("custom.interface"));

    bytes4[6] internal interfaces = [
        type(ILibCento).interfaceId,
        type(IBitmap).interfaceId,
        type(IERC165).interfaceId,
        type(IERC173).interfaceId,
        type(IFacetManager).interfaceId,
        type(IObservability).interfaceId
    ];
}

