// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Cento, $CentoProxy} from "../Cento.sol";
import {CentoCall} from "../_CentoCall.sol";
import {Facet} from "cento/structs/Facet.sol";
import {IERC165} from "cento/interfaces/IERC165.sol";
import {IObservability} from "cento/interfaces/IObservability.sol";

library Observability {

    function getFacets($CentoProxy proxy) internal view returns (address[] memory) {
        bytes memory _calldata = CentoCall._append(Cento.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacets, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (address[])
        );
    }

    function getFacetEntries($CentoProxy proxy) internal view returns (Facet[] memory) {
        bytes memory _calldata = CentoCall._append(Cento.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacetEntries, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (Facet[])
        );
    }

    function getFacetAt($CentoProxy proxy, uint8 index) internal view returns (address) {
        bytes memory _calldata = CentoCall._append(Cento.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacetAt, (index))
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (address)
        );
    }

    function getFacetCount($CentoProxy proxy) internal view returns (uint16) {
        bytes memory _calldata = CentoCall._append(Cento.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacetCount, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (uint16)
        );
    }

    function getFirstFreeSlot($CentoProxy proxy) internal view returns (uint8) {
        bytes memory _calldata = CentoCall._append(Cento.OBSERVABILITY,
            abi.encodeCall(IObservability.getFirstFreeSlot, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (uint8)
        );
    }

    function supportsInterface($CentoProxy proxy, bytes4 interfaceId) external view returns (bool) {
        bytes memory _calldata = CentoCall._append(Cento.OBSERVABILITY,
            abi.encodeCall(IERC165.supportsInterface, (interfaceId))
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxy.unwrap(proxy), _calldata),
            (bool)
        );
    }
}
