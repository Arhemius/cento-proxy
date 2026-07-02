// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV1, $CentoProxyV1} from "../../CentoV1.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {IERC173} from "cento/interfaces/IERC173.sol";

library Ownership {

    function owner($CentoProxyV1 proxy) internal view returns (address) {
        bytes memory _calldata = CentoCall._append(CentoV1.OWNERSHIP,
            abi.encodeCall(IERC173.owner, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (address)
        );
    }

    function transferOwnership($CentoProxyV1 proxy, address newOwner) internal {
        bytes memory _calldata = CentoCall._append(CentoV1.OWNERSHIP,
            abi.encodeCall(IERC173.transferOwnership, (newOwner))
        );
        CentoCall._call($CentoProxyV1.unwrap(proxy), _calldata);
    }

}