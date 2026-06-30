// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// add ERC functions back - we need legacy only for legacy
import {FacetManager} from "./protocol/_FacetManager.sol";
import {Observability} from "./protocol/_Observability.sol";
import {Ownership} from "./protocol/_Ownership.sol";
import {CentoRouter} from "cento/CentoRouter.sol";

/// @dev Strongly-typed proxy handle (SDK boundary type)
/// Rename it to how your protocol wants to be called <$AAVEv3>
type $CentoProxy is address;

/// @dev the constant users will interact with. Rename to (example): <AAVEv3>
/// Paste your deployed proxy address here
$CentoProxy constant CentoProxy = $CentoProxy.wrap(address(
    uint160(uint256(keccak256(abi.encodePacked(
        bytes1(0xff),
        address(uint160(uint256(bytes32(keccak256("deployer-address"))))),
        bytes32(keccak256("cento-proxy-v1")),
        keccak256(type(CentoRouter).creationCode)
    ))))
));
// I'll make my own constant for testing
// address[3]  internal facets = [address(FacetManager), address(Ownership), address(Observability)];
// CentoRouter internal cento = new CentoRouter(owner, facets);
// $CentoProxy internal CentoProxy = address(cento);

/// @dev Central facet registry (single source of truth)
/// Rename it for your protocol name and add your own facets here <CentoAAVEv3>
library Cento {
    uint8 internal constant FACET_MANAGER = 0;
    uint8 internal constant OWNERSHIP     = 1;
    uint8 internal constant OBSERVABILITY = 2;
}

using { FacetManager.atomicUpdate           } for $CentoProxy global;

using { Ownership.owner,
        Ownership.transferOwnership         } for $CentoProxy global;

using { Observability.getFacets, 
        Observability.getFacetEntries,
        Observability.getFacetAt,
        Observability.getFacetCount,
        Observability.getFirstFreeSlot,
        Observability.supportsInterface     } for $CentoProxy global;

// Standard interaction examples:
// Facet[] memory facets = CentoProxy.getFacetEntries();
// CentoProxy.atomicUpdate(setF, addI, remI, migrator, _calldata);

// Standard interactions (address is stored elsewhere or we use our constant):
// bool supported = IERC165(address(CentoProxy)).supportsInterface(bytes4(0xBEEFBEEF));
// address owner = IERC173($CentoProxy.unwrap(CentoProxy)).owner();