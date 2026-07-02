// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV2, $CentoProxyV2} from "../../CentoV2.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {CounterV2} from "src/protocol/v2/CounterV2.sol";

library _CounterV2 {
    
    function inc($CentoProxyV2 proxy) internal {
        bytes memory _calldata = CentoCall._append(CentoV2.COUNTER_V2,
            abi.encodeCall(CounterV2.inc, ())
        );
        CentoCall._call($CentoProxyV2.unwrap(proxy), _calldata);
    }

    function dec($CentoProxyV2 proxy) internal {
        bytes memory _calldata = CentoCall._append(CentoV2.COUNTER_V2,
            abi.encodeCall(CounterV2.dec, ())
        );
        CentoCall._call($CentoProxyV2.unwrap(proxy), _calldata);
    }
}