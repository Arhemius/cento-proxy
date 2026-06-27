// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Cento, $CentoProxy} from "../Cento.sol";
import {CentoCall} from "../_CentoCall.sol";
import {IERC173} from "src/interfaces/IERC173.sol";

library Ownership {

    function owner($CentoProxy proxy) internal view returns (address) {
        bytes memory _calldata = CentoCall._append(Cento.OWNERSHIP,
            abi.encodeCall(IERC173.owner, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (address)
        );
    }

    function transferOwnership($CentoProxy proxy, address newOwner) internal {
        bytes memory _calldata = CentoCall._append(Cento.OWNERSHIP,
            abi.encodeCall(IERC173.transferOwnership, (newOwner))
        );
        CentoCall._call($CentoProxy.unwrap(proxy), _calldata);
    }

}