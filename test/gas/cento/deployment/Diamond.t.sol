// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Diamond} from "test/gas/cento/_diamond-2/src/Diamond.sol";
import {DiamondSigs} from "support/fixtures/dummies/DiamondSigs.sol";
import {IDiamondCut} from "test/gas/cento/_diamond-2/src/interfaces/IDiamondCut.sol";
import {DiamondInit} from "test/gas/cento/_diamond-2/src/upgradeInitializers/DiamondInit.sol";
import {SimpleActors} from "support/actors/SimpleActors.sol";
import {GasReportLogger} from "support/helpers/GasReportLogger.sol";
import {BroadcastParser} from "support/helpers/BroadcastParser.sol";

contract CentoDeploymentGasTest is Test, DiamondSigs, SimpleActors, GasReportLogger, BroadcastParser {

    bytes private _calldata;
    
    function setUp() public {
        loadBroadcast("broadcast/_DeployDiamondGas.s.sol/31337/run-latest.json");
        DiamondDeploymentCut[0].facetAddress = byContract("DiamondLoupeFacet").contractAddress;
        DiamondDeploymentCut[1].facetAddress = byContract("OwnershipFacet").contractAddress;
        _calldata = abi.encodeCall(IDiamondCut.diamondCut, 
            (DiamondDeploymentCut, byContract("DiamondInit").contractAddress, abi.encodeCall(DiamondInit.init, ()))
        );
        setWidths(20, 13, 13);
    }

    function test_00_00_header() public view {
        table("Diamond Standard");
    }

    function test_01_00_deployDiamondCutFacet() public {
        th("DiamondCutFacet", formatLength(diamondCut), deploymentGas("DiamondCutFacet"));
    }

    function test_01_01_deployOwnershipFacet() public {
        th("OwnershipFacet", formatLength(ownership), deploymentGas("OwnershipFacet"));
    }

    function test_01_02_deployDiamondLoupeFacet() public {
        th("DiamondLoupeFacet", formatLength(diamondLoupe), deploymentGas("DiamondLoupeFacet"));
    }

    function test_01_03_deployDiamondInit() public {
        th("DiamondInit", formatLength(diamondInit), deploymentGas("DiamondInit"));
    }

    function test_01_04_deployDiamond() public {
        Diamond diamond = new Diamond(owner, diamondCut);
        th("Diamond", formatLength(address(diamond)), deploymentGas("Diamond"));
        th("Diamond (bootstrap)", "", callGas(_calldata));
        hr();
    }

    function test_02_00_measureTotal() public {
        th("Total:", "full router", deploymentGas("Diamond") + callGas(_calldata));
        tr("Total:", "with facets", deploymentGas("Diamond") + callGas(_calldata) + 
            deploymentGas("DiamondCutFacet") + 
            deploymentGas("OwnershipFacet") +  
            deploymentGas("DiamondLoupeFacet") +
            deploymentGas("DiamondInit")
        );
    }

    function test_99_99_footer() public view {
        table();
    }
}

//   [Gas]    ╭─ Diamond Standard ───╮
//   [Gas]    │                      ├───────────────┬────────────────╮
//   [Gas]    │ DiamondCutFacet      │  4,232 Bytes  │    966,047 gas │
//   [Gas]    │ OwnershipFacet       │    542 Bytes  │    169,651 gas │
//   [Gas]    │ DiamondLoupeFacet    │  2,565 Bytes  │    607,839 gas │
//   [Gas]    │ DiamondInit          │    351 Bytes  │    128,959 gas │
//   [Gas]    │ Diamond              │    268 Bytes  │    262,171 gas │
//   [Gas]    │ Diamond (bootstrap)  │               │    311,051 gas │
//   [Gas]    ├──────────────────────┼───────────────┼────────────────┤
//   [Gas]    │ Total:               │ full router   │    573,222 gas │
//   [Gas]    │                      │ with facets   │  2,445,718 gas │
//   [Gas]    ╰──────────────────────┴───────────────┴────────────────╯