// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {FacetManager} from "src/cento/facets/FacetManager.sol";
import {Ownership} from "src/cento/facets/Ownership.sol";
import {Observability} from "src/cento/facets/Observability.sol";
import {CentoRouter} from "src/cento/CentoRouter.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {BroadcastParser} from "support/helpers/BroadcastParser.sol";

contract CentoDeploymentGasTest is Test, SimpleActors, GasReportLogger, BroadcastParser {

    function setUp() public {
        loadBroadcast("broadcast/_DeployCentoGas.s.sol/31337/run-latest.json");
        setWidths(20, 13, 13);
        vm.startPrank(owner);
    }

    function test_00_00_header() public view {
        table("Cento Proxy");
    }

    function test_01_00_deployFacetManager() public {
        FacetManager fm = new FacetManager();
        th("FacetManager", formatLength(address(fm)), deploymentGas("FacetManager"));
    }

    function test_01_01_deployOwnership() public {
        Ownership own = new Ownership();
        th("Ownership", formatLength(address(own)), deploymentGas("Ownership"));
    }

    function test_01_02_deployObservability() public {
        Observability obs = new Observability();
        th("Observability", formatLength(address(obs)), deploymentGas("Observability"));
    }

    function test_01_03_deployCentoRouter() public {
        address fm  = address(new FacetManager());
        address own = address(new Ownership());
        address obs = address(new Observability());
        CentoRouter cr = new CentoRouter(owner, [fm, own, obs]);
        th("CentoRouter", formatLength(address(cr)), deploymentGas("CentoRouter"));
        hr();
    }

    function test_02_00_measureTotal() public {
        th("Total:", "just router", deploymentGas("CentoRouter"));
        tr("Total:", "with facets", deploymentGas("CentoRouter") + 
            deploymentGas("FacetManager") + 
            deploymentGas("Ownership") + 
            deploymentGas("Observability")
        );
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ Cento Proxy ────────╮
//   [Gas]    │                      ├───────────────┬────────────────╮
//   [Gas]    │ FacetManager         │  1,938 Bytes  │    469,459 gas │
//   [Gas]    │ Ownership            │    454 Bytes  │    151,009 gas │
//   [Gas]    │ Observability        │  1,625 Bytes  │    403,832 gas │
//   [Gas]    │ CentoRouter          │    472 Bytes  │    369,939 gas │
//   [Gas]    ├──────────────────────┼───────────────┼────────────────┤
//   [Gas]    │ Total:               │ just router   │    369,939 gas │
//   [Gas]    │                      │ with facets   │  1,394,239 gas │
//   [Gas]    ╰──────────────────────┴───────────────┴────────────────╯