// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {$CentoProxyV1} from "interaction/CentoV1.sol";

contract CastAdapter {

    $CentoProxyV1 public immutable CentoProxy;

    constructor(address router) {
        CentoProxy = $CentoProxyV1.wrap(router);
    }

    function getFacetAt(uint8 index) external view returns (address) {
        return CentoProxy.getFacetAt(index);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return CentoProxy.supportsInterface(interfaceId);
    }

    function inc() external {
        CentoProxy.inc();
    } 
}