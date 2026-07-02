// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {FacetManager} from "./protocol/v1/_FacetManager.sol";
import {Observability} from "./protocol/v1/_Observability.sol";
import {Ownership} from "./protocol/v1/_Ownership.sol";
import {_CounterV1} from "./protocol/v1/_CounterV1.sol";

/// @dev Strongly-typed proxy handle (SDK boundary type)
/// Rename it to how your protocol wants to be called <$AAVEv3>
type $CentoProxyV1 is address;

/// @dev the constant users will interact with. Rename to (example): <AAVEv3>
/// Paste your deployed proxy address here
$CentoProxyV1 constant CentoProxy = $CentoProxyV1.wrap(address(0));


/// @dev Central facet registry (single source of truth)
/// Rename it for your protocol name and add your own facets here <CentoAAVEv3>
library CentoV1 {
    uint8 internal constant FACET_MANAGER = 0;
    uint8 internal constant OWNERSHIP     = 1;
    uint8 internal constant OBSERVABILITY = 2;
    uint8 internal constant COUNTER_V1    = 3;
}

using { FacetManager.atomicUpdate           } for $CentoProxyV1 global;

using { Ownership.owner,
        Ownership.transferOwnership         } for $CentoProxyV1 global;

using { Observability.getFacets, 
        Observability.getFacetEntries,
        Observability.getFacetAt,
        Observability.getFacetCount,
        Observability.getFirstFreeSlot,
        Observability.supportsInterface     } for $CentoProxyV1 global;

using { _CounterV1.inc                      } for $CentoProxyV1 global;