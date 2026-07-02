// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV2, $CentoProxyV2} from "../../CentoV2.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {IERC173} from "cento/interfaces/IERC173.sol";

library Ownership {

    function owner($CentoProxyV2 proxy) internal view returns (address) {
        bytes memory _calldata = CentoCall._append(CentoV2.OWNERSHIP,
            abi.encodeCall(IERC173.owner, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV2.unwrap(proxy), _calldata),
            (address)
        );
    }

    function transferOwnership($CentoProxyV2 proxy, address newOwner) internal {
        bytes memory _calldata = CentoCall._append(CentoV2.OWNERSHIP,
            abi.encodeCall(IERC173.transferOwnership, (newOwner))
        );
        CentoCall._call($CentoProxyV2.unwrap(proxy), _calldata);
    }

}