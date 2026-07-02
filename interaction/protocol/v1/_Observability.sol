// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {CentoV1, $CentoProxyV1} from "../../CentoV1.sol";
import {CentoCall} from "../../_CentoCall.sol";
import {Facet} from "cento/structs/Facet.sol";
import {IERC165} from "cento/interfaces/IERC165.sol";
import {IObservability} from "cento/interfaces/IObservability.sol";

library Observability {

    function getFacets($CentoProxyV1 proxy) internal view returns (address[] memory) {
        bytes memory _calldata = CentoCall._append(CentoV1.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacets, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (address[])
        );
    }

    function getFacetEntries($CentoProxyV1 proxy) internal view returns (Facet[] memory) {
        bytes memory _calldata = CentoCall._append(CentoV1.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacetEntries, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (Facet[])
        );
    }

    function getFacetAt($CentoProxyV1 proxy, uint8 index) internal view returns (address) {
        bytes memory _calldata = CentoCall._append(CentoV1.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacetAt, (index))
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (address)
        );
    }

    function getFacetCount($CentoProxyV1 proxy) internal view returns (uint16) {
        bytes memory _calldata = CentoCall._append(CentoV1.OBSERVABILITY,
            abi.encodeCall(IObservability.getFacetCount, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (uint16)
        );
    }

    function getFirstFreeSlot($CentoProxyV1 proxy) internal view returns (uint8) {
        bytes memory _calldata = CentoCall._append(CentoV1.OBSERVABILITY,
            abi.encodeCall(IObservability.getFirstFreeSlot, ())
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (uint8)
        );
    }

    function supportsInterface($CentoProxyV1 proxy, bytes4 interfaceId) external view returns (bool) {
        bytes memory _calldata = CentoCall._append(CentoV1.OBSERVABILITY,
            abi.encodeCall(IERC165.supportsInterface, (interfaceId))
        );
        return abi.decode(
            CentoCall._staticcall($CentoProxyV1.unwrap(proxy), _calldata),
            (bool)
        );
    }
}
