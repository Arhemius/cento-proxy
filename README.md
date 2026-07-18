# Cento Proxy

> **A modular proxy pattern for the Ethereum Virtual Machine that combines facet indices for protocol routing with selector-based routing for compatibility standards, reducing deployment and upgrade costs while preserving full interoperability with existing Ethereum tooling.**

## Overview

Cento Proxy is a reference implementation of an alternative modular upgrade pattern. Rather than routing all functions through selectors (as in ERC-2535), Cento separates two distinct concerns:

- **Protocol routing**: Compact facet indices for protocol-specific functions
- **Compatibility routing**: Selector-based routing for standard interfaces (ERC-165, ERC-173, etc.)

This separation eliminates selector management as a permanent maintenance cost while ensuring existing Ethereum infrastructure continues functioning without modification. The result is a system with significantly lower deployment and upgrade costs, simpler routing metadata, and native compatibility with the Ethereum ecosystem.

---

## Quick Start

**Build**
```bash
forge build
```

**Test**
```bash
forge test
```

**Benchmarks**
```bash
release forge test --match-path "test/gas/**" --gas-report --isolate
```

**Documentation**
```bash
forge doc
```

See [Development Workflow](#development-workflow) for complete setup and testing instructions.

---

## Efficiency & Cost Analysis

The following benchmarks compare the reference implementation contained in this repository against the Diamond Standard (ERC-2535) reference implementation.

### Deployment Costs

Cento substantially reduces both initial router deployment and complete protocol initialization:

| Metric | Cento Proxy | Diamond Standard | Savings |
|:--|--:|--:|--:|
| Router deployment | **369,939 gas** | **573,222 gas** | **35.4%** |
| Complete protocol deployment | **1,394,239 gas** | **2,445,718 gas** | **43.0%** |

### Upgrade Costs

For protocols performing atomic multi-facet updates, Cento provides dramatic improvements (example facets expose 10 functions each):

| Operation | Cento Proxy | Diamond Standard | Savings |
|:--|--:|--:|--:|
| Add 5 facets | **172,264 gas** | **1,390,250 gas** | **87.6%** |
| Update 5 facets | **83,722 gas** | **378,380 gas** | **77.9%** |
| Remove 5 facets | **57,160 gas** | **341,986 gas** | **83.3%** |

### Introspection Costs

Core introspection functionality provides the toolset for various query tooling, while also being cheap enough to be used by other protocols:

| Facet Count  | Cento Proxy | Diamond Standard | Savings |
|:--|--:|--:|--:|
| 3 (baseline) | **15,242 gas** | **63,580 gas** | **76.0%** |
| 4 | **18,434 gas** | **114,210 gas** | **83.8%** |
| 5 | **21,626 gas** | **164,833 gas** | **86.8%** |
| 8 | **31,227 gas** | **333,994 gas** | **90.6%** |

### Routing Performance

Standard interface calls maintain near-identical performance:

| Call Type | Cento Proxy | Diamond Standard | Delta |
|:--|--:|--:|--:|
| Standard routing | **4,873 gas** | **4,898 gas** | **-25 gas (0.5%)** |
| Protocol-to-protocol routing | **4,909 gas** | **4,898 gas** | **+11 gas (0.2%)** |

The 11-gas overhead for protocol-to-protocol calls is a deliberate tradeoff: it enables the 77–87% reduction in upgrade costs while maintaining compatibility-standard performance.

### Architectural Comparison

| Dimension | Cento | Diamond |
|:--|--:|--:|
| Selector management required | ❌ | ✅ |
| Selector collision risk | ❌ | ✅ |
| Router bytecode | 472 B | 268 B |
| Reference implementation | 4,489 B | 7,958 B |

## Key Features

**Routing & Architecture**
- Hybrid routing model combining compact facet indices and function selectors
- Index-based routing for protocol functions; selector-based routing for compatibility standards
- Immutable router contract (no governance or upgrade surface)
- Up to 256 facets per protocol

**Operational Simplicity**
- Eliminates selector management entirely for protocol-specific functions
- No selector collision risk or collateral damage during updates
- Atomic facet installation, replacement, and removal
- Optional storage migration framework during upgrades

**Compatibility & Standards**
- Full ERC-165 interface introspection support
- Native ERC-173 ownership pattern
- Seamless integration with existing Ethereum tooling and wallets
- Support for delegating to standard interface implementations

**Quality & Production Readiness**
- Production-quality reference implementation
- Comprehensive Foundry test suite with gas benchmarking
- Configurable deployment and upgrade scripts
- Complete NatSpec documentation
- ERC-7201 namespaced storage for safe upgrades
- Deterministic storage locations across protocol versions
- Migration examples

---

# Repository Structure

```text
.
├── interaction/
├── lib/
├── logs/
├── script/
├── src/
│   ├── cento/
│   │   ├── facets/
│   │   ├── interfaces/
│   │   ├── libraries/
│   │   ├── migrators/
│   │   ├── structs/
│   │   └── types/
│   └── protocol/
├── test/
└── README.md
```

The repository contains both the complete reference implementation of Cento Proxy and example protocols demonstrating deployment, upgrades, benchmarking and storage migration.

---

# Development Workflow

## Requirements

- Solidity **^0.8.36**
- Foundry **^1.7.1**
- forge-std **^1.16.2**
- lcov *(optional, for HTML coverage reports)*

---

## Build

Compile the entire repository.

```bash
forge build
```

Compile using the release profile.

```bash
release forge build
```

Clean build artifacts.

```bash
forge clean
```

---

## Test

Run the complete test suite.

```bash
forge test
```

Run the release configuration.

```bash
release forge test
```

> Note: `release` stands for `FOUNDRY_PROFILE=release`. To use alias, add to your bash.rc:
>
> ```bash
> release() {
>     FOUNDRY_PROFILE=release "$@"
> }
> ```

Run an individual test module.

```bash
forge test \
    --match-path "test/unit/libraries/LibCento/*.t.sol" \
    -vvvvv
```

Verify that debug assertions have been removed from the release build.

> Ensure `src/cento/libraries/LibDebug.sol` contains:
>
> ```solidity
> bool constant ON = false;
> ```

```bash
release forge test \
    --match-path test/_support/base/DebugTest/DebugErasureTest.t.sol \
    -vv
```

---

## Benchmark

Generate Foundry gas reports.

```bash
release forge test \
    --match-path "test/gas/cento/**" \
    --gas-report
```

Print benchmark values.

```bash
release forge test \
    --match-path "test/gas/cento/**" \
    -vv \
| grep "\[Gas\]"
```

Measure isolated execution costs (recommended).

```bash
release forge test \
    --match-path "test/gas/cento/**" \
    --isolate \
    -vv \
| grep "\[Gas\]"
```

Generate gas snapshots.

```bash
release forge snapshot \
    --match-path "test/gas/cento/**"
```

Protocol-level benchmark suite.

```bash
release forge test \
    --match-path "test/gas/protocol/**" \
    --gas-report
```

```bash
release forge test \
    --match-path "test/gas/protocol/**" \
    --isolate \
    -vv \
| grep "\[Gas\]"
```

```bash
release forge snapshot \
    --match-path "test/gas/protocol/**"
```

---

## Coverage

Generate a coverage report.

```bash
forge coverage
```

Generate an HTML coverage report (for installation see this [**tutorial**](https://rareskills.io/post/foundry-forge-coverage)).

```bash
forge coverage --report lcov
genhtml lcov.info \
    --branch-coverage \
    --output-dir coverage
```

## Deployment

The repository includes deployment scripts for local development and benchmarking.

Start a local Anvil node.

```bash
anvil
```

Deploy the reference implementation.

```bash
release forge script script/deployment/DeployCento.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast \
    --private-key <PRIVATE_KEY> \
    -vvvvv
```

Upgrade an existing deployment.

```bash
release forge script script/deployment/UpgradeCento.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast \
    --private-key <PRIVATE_KEY> \
    -vvvvv
```

Reset the local chain.

```bash
cast rpc anvil_reset \
    --rpc-url http://127.0.0.1:8545
```

---

## Operating a Protocol

Transfer protocol ownership.

```bash
forge script script/operations/v1/TransferOwnership.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast \
    --private-key <PRIVATE_KEY> \
    -vvvvv
```

Query the routing table.

```bash
forge script script/operations/v1/GetFacetEntries.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    -vvvvv
```

Inspect protocol state.

```bash
forge script script/operations/v1/GetFacetState.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    -vvvvv
```

Read protocol ownership.

```bash
forge script script/operations/v1/GetOwner.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --debug
```

---

## Cast Adapter

A Cast adapter is included to simplify interaction with Cento protocols from the command line.

Deploy the adapter.

```bash
release forge script script/operations/v1/cast/DeployCastAdapter.s.sol \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast \
    --private-key <PRIVATE_KEY> \
    -vvvvv
```

Example calls.

```bash
cast call <CAST_ADAPTER> \
    "getFacetAt(uint8)" \
    2 \
    --rpc-url http://127.0.0.1:8545
```

```bash
cast call <CAST_ADAPTER> \
    "supportsInterface(bytes4)" \
    0xBEEFBEEF \
    --rpc-url http://127.0.0.1:8545
```

---

## Architecture

### Design Philosophy

Function selectors were designed to identify externally callable entry points and enable ABI encoding/decoding. They succeed at this purpose.

In selector-centric modular architectures, selectors additionally serve as facet identifiers. This conflation creates constraints:

- Adding a function requires adding a selector and routing entry
- Removing a function requires removing both
- Protocol composition becomes selector-dependent rather than module-dependent

This pattern treats protocol routing and interface compatibility as independent concerns:

- **Protocol routing** uses compact facet indices (one byte per facet)
- **Interface compatibility** uses standard function selectors

Result: facets become first-class routing entities, selector tables remain focused on interoperability, and routing metadata scales with module count rather than function count.

### Routing Model

Cento employs a hybrid routing architecture:

**Protocol Routing**: Compact facet indices appended to calldata
- Enables atomic multi-facet updates
- Routing metadata scales with facet count, not function count
- Updating entire facet requires modifying single routing entry

**Compatibility Routing**: Standard function selectors
- Compatibility standards (ERC-165, ERC-173) use native selector routing
- Existing wallets, explorers, and infrastructure work without modification
- Seamless integration with all Ethereum tooling

### System Components

**Router Contract**
- Minimal immutable proxy handling routing dispatch
- Responsibilities: decode routing metadata, locate facet, execute via `delegatecall`
- Business logic never resides in the router

**Facets**
- Isolated modules responsible for single protocol concerns
- Common facets: ownership, administration, token logic, governance, observability
- Protocols compose facets up to routing table capacity (256 facets)

**Storage Model**
- ERC-7201 namespaced storage for deterministic location assignment
- All shared state accessed through `LibCento`
- Safe upgrades with facet isolation
- Optional storage migration framework

**Atomic Updates**
- Single transaction can install, replace, or remove facets
- Atomic interface registration and storage migrations
- All-or-nothing semantics: every modification succeeds or entire update reverts

**Observability**
- Inspection utilities for installed facets, routing entries, and supported interfaces
- Protocol administration queries independent from routing logic

---

# Benchmark Methodology

All benchmark values in this README are generated directly from reference implementation contained in this repository using Foundry gas benchmarking tools.

Deployment benchmarks compare complete protocol initialization (router + essential facets).
Upgrade benchmarks compare equivalent multi-facet atomic updates.
Routing benchmarks compare identical protocol calls.

Raw benchmark scripts are available in `test/gas/`. Running the benchmark suite locally should reproduce published values.

---

## Design Tradeoffs

Every engineering design makes intentional tradeoffs. Cento's design prioritizes upgrade efficiency and operational simplicity over maximizing single-call routing performance.

### Primary Tradeoff: Routing Performance vs. Upgrade Cost

Protocol-to-protocol calls append a single routing byte to calldata, increasing routing cost by approximately **11 gas** (0.2%) compared to Diamond. This is the deliberate design tradeoff that enables:

- **77–87% reduction in upgrade costs** for multi-facet operations
- **43% reduction in protocol deployment costs**
- **Elimination of selector management** from protocol maintenance

For most protocols, upgrade frequency far outweighs call frequency, making this tradeoff strongly favorable.

### Secondary Constraints

- **Routing table capacity**: 256 facets maximum (sufficient for virtually all protocol architectures)
- **Protocol functions**: Require generated routing wrappers (minimal overhead, handled by SDK)

### Advantages

- Eliminates selector management and collision risk
- Dramatically lower deployment and upgrade costs
- Simpler deployment and upgradability for facet management part
- Batch calls benefit from per-facet slot warmups compared to per-selector ones
- Facets may implement custom `receive()` functions

---

## Positioning Relative to ERC-2535 (Diamond Standard)

ERC-2535 pioneered modular smart contract architecture through selector-based routing. Cento preserves this modularity while introducing a fundamental architectural shift:

**Diamond Standard approach**: All functions route through selectors
- Every function requires selector mapping
- Upgrade cost scales with number of functions modified
- Selector management is permanent operational overhead

**Cento approach**: Separate protocol routing from compatibility routing
- Protocol functions use facet indices (metadata scales with facet count)
- Compatibility standards continue using selectors (no change to existing interfaces)
- Selector management eliminated from protocol development

This is not a replacement for Diamond; it is an **alternative design point** optimizing for upgrade efficiency and operational simplicity. Projects prioritizing maximum single-call performance or already heavily invested in Diamond may prefer to remain on that path. Projects prioritizing low upgrade costs and minimal management overhead should evaluate Cento.

---

# Documentation

Documentation can be generated locally with:

```bash
forge doc
```

And served on localhost:3000 with:

```bash
forge doc --serve --port 3000
```

---

## Compatibility Standards

The reference implementation includes native support for:

- **ERC-165**: Interface introspection
- **ERC-173**: Ownership pattern

Additional standards (ERC-20, ERC-721, ERC-1155, etc.) can be implemented as standard compatibility facets, operating through conventional selector-based routing. These will be added in the routing code, locking implementation to specific indices. Be sure to add all standards that you plan to support upon deployment of Cento Router.

---

## ERC Proposal

Cento Proxy is proposed as an Ethereum Request for Comments (ERC) standard. The formal specification draft is available in the `ERC-83XX.md` file.

The ERC submission process follows the standardization pathway for core Ethereum protocol extensions. Community discussion and feedback are invited.

---

## Contributing

Issues, discussions, and pull requests are welcome.

**For technical changes:**
- Include benchmark results for architectural or gas-related modifications
- Maintain test coverage for new functionality
- Follow NatSpec documentation standards

**For standards discussion:**
- Reference the ERC specification draft
- Align contributions with proposed standard semantics

---

## Roadmap

The current reference implementation is considered feature complete and production-ready.

**Immediate priorities:**
- ERC standardization process
- Independent security audit
- Configurable BST generator script for Compatibility routing

**Medium-term:**
- viem integration
- ethers integration
- Tooling and deployment framework

**Long-term:**
- Formal verification
- Extended benchmark suites (L2 optimization, cross-chain patterns)
- Introduction of other Proxy patterns on top of the same routing model
- Architecture documentation and educational materials

---

## Get Support

If you have questions or would like to discuss Cento - [email me](mailto:artembuchihin@gmail.com).

## Author

This example implementation was written by Artem Buchikhin.

Contact:

- artembuchihin@gmail.com
- https://github.com/Arhemius

---

# License

This project is licensed under the MIT License.

See the accompanying `LICENSE` file for details.