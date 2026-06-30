// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {$CentoProxy} from "interaction/Cento.sol";

contract CastAdapter {

    $CentoProxy public immutable CentoProxy;

    constructor(address router) {
        CentoProxy = $CentoProxy.wrap(router);
    }

    function getFacetAt(uint8 index) external view returns (address) {
        return CentoProxy.getFacetAt(index);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return CentoProxy.supportsInterface(interfaceId);
    }
}