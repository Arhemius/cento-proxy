// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoRouter} from "cento/CentoRouter.sol";
import {LibCentoHarness} from "support/harnesses/LibCentoHarness.sol";

contract CentoRouterAdapter is LibCentoHarness, CentoRouter {

    constructor (address _contractOwner, address[3] memory facetAddresses) 
        CentoRouter(_contractOwner, facetAddresses) 
    {}

}