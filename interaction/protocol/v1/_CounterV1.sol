// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV1, $CentoProxyV1} from "../../CentoV1.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {CounterV1} from "src/protocol/v1/CounterV1.sol";

library _CounterV1 {
    
    function inc($CentoProxyV1 proxy) internal {
        bytes memory _calldata = CentoCall._append(CentoV1.COUNTER_V1,
            abi.encodeCall(CounterV1.inc, ())
        );
        CentoCall._call($CentoProxyV1.unwrap(proxy), _calldata);
    }
}