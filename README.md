# Cento Proxy

> **A modular proxy pattern for the Ethereum Virtual Machine that identifies facets through routing indices while preserving selector-based compatibility for Ethereum standards, reducing deployment and upgrade costs without sacrificing interoperability.**

## Overview

Cento Proxy separates **protocol routing** from **interface compatibility**:

- **Protocol routing** uses compact facet indices (one byte per facet) for implementation modules
- **Interface compatibility** maps standardized Ethereum function selectors to routing indices

This separation eliminates selector management as a permanent protocol maintenance cost while ensuring existing Ethereum infrastructure continues functioning without modification. The result is a system with significantly lower deployment and upgrade costs, simpler routing metadata, and native compatibility with the Ethereum ecosystem.

The reference implementation is a complete boilerplate project: fork it, build your protocol, and deploy immediately. It includes comprehensive examples for deployment, atomic upgrades, migration, benchmarking, testing, and operational management, with no selector management overhead.

---

## Requirements

- Solidity **^0.8.36**
- Foundry **^1.7.1**
- forge-std **^1.16.2**
- lcov *(optional, for HTML coverage reports)*

## Quick Start

**Installation**

> Clone the repository:
> 
> ```bash
> git clone git@github.com:Arhemius/cento-proxy.git
> cd cento-proxy
> ```
> 
> Install Foundry (if not already installed):
> 
> ```bash
> curl -L https://foundry.paradigm.xyz | bash
> ```
> 
> Restart your shell:
> 
> ```bash
> source ~/.bashrc
> # or
> source ~/.zshrc
> ```
> 
> Install Foundry v1.7.1 or higher:
> 
> ```bash
> foundryup --install 1.7.1
> ```
> 
> Install project dependencies:
> 
> ```bash
> forge install foundry-rs/forge-std
> ```

**Build and Test**

```bash
forge build
forge test
```

**Benchmarks**

Run the complete benchmark suite:

```bash
release forge test --match-path "test/gas/**" --isolate -vv | grep "\[Gas\]"
```

> Note: `release` stands for `FOUNDRY_PROFILE=release`. To use alias, add to your .bashrc or .zshrc:
>
> ```bash
> release() {
>     FOUNDRY_PROFILE=release "$@"
> }
> ```

**Documentation**

Launch the local documentation server:

```bash
forge doc --serve --port 3000
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
- Index-based routing for protocol functions; selector-based routing support for compatibility standards
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

# Development Workflow

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

Generate and visualize depolyment costs (for Cento and Diamond):

> Start a local Anvil node (in second terminal):
>
> ```bash
> anvil
> ```
> 
> Run benchmark-specific deployment scripts for Cento:
>
> ```bash
> release forge script test/gas/cento/deployment/_DeployCentoGas.s.sol \
>     --rpc-url http://127.0.0.1:8545 \
>     --broadcast \
>     --private-key <PRIVATE_KEY> \
>     -vvvvv
> ```
>
> And Diamond:
>
> ```bash
> release forge test/gas/cento/deployment/_DeployDiamondGas.s.sol \
>     --rpc-url http://127.0.0.1:8545 \
>     --broadcast \
>     --private-key <PRIVATE_KEY> \
>     -vvvvv
> ```
>
> Now you can execute the deployment benchmark test:
>
> ```bash
> release forge test \
>     --match-path "test/gas/cento/deployment/**" \
>     --isolate \
>     -vv \
> | grep "\[Gas\]"
> ```

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
forge coverage --report lcov && genhtml lcov.info \
    --branch-coverage \
    --output-dir coverage
```

---

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
    --vvvvv
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

# Architecture

## Design Philosophy

Function selectors were designed to identify externally callable entry points and enable ABI encoding/decoding. They succeed at this purpose.

In selector-centric modular architectures, selectors additionally serve as facet identifiers. This conflation creates constraints:

- Adding a function requires adding a selector and routing entry
- Removing a function requires removing both
- Protocol composition becomes selector-dependent rather than module-dependent

This pattern treats protocol routing and interface compatibility as independent concerns:

- **Protocol routing** uses compact facet indices (one byte per facet)
- **Interface compatibility** uses standard function selectors for Ethereum interfaces

Result: facets become first-class routing entities, selector tables remain focused on interoperability, and routing metadata scales with module count rather than function count.

## Routing Model

Cento employs a hybrid routing architecture:

**Protocol Routing**: Compact facet indices appended to calldata
- Enables atomic multi-facet updates
- Routing metadata scales with facet count, not function count
- Updating entire facet requires modifying single routing entry

**Compatibility Routing**: Standard function selectors
- Compatibility standards (like ERC-165, ERC-173, and others) use native selector routing
- Existing wallets, explorers, and infrastructure work without modification
- Seamless integration with all Ethereum tooling

## System Components

The reference implementation consists of a minimal immutable router, three core facets, four standard interfaces, and two supporting libraries. Together they provide a complete foundation for building modular protocols using index-based facet routing.

### Cento Router

The `CentoRouter` is an immutable proxy responsible exclusively for execution dispatch.

- Decodes routing metadata appended to calldata
- Resolves the target facet through the routing table
- Strips routing metadata before `delegatecall`
- Contains no protocol business logic

### Core Facets

The reference implementation provides three reusable facets covering the essential protocol lifecycle.

**FacetManager**
- Atomic installation, replacement, and removal of facets
- Atomic interface registration and deregistration
- Optional storage migration execution during upgrades
- Complete protocol evolution through a single transaction

**Ownership**
- ERC-173 ownership management
- Administrative access control
- Ownership transfer operations

**Observability**
- Inspection of installed facets and routing table state
- Supported interface discovery
- DevOps-oriented protocol introspection

### Standard Interfaces

The reference implementation exposes four interfaces defining protocol administration and interoperability.

- **IFacetManager** – facet lifecycle management
- **IObservability** – protocol introspection
- **IERC173** – ERC-173 ownership operations
- **IERC165** – ERC-165 interface compatibility

### Supporting Libraries

**LibCento**
- Implements the ERC-7201 storage model
- Defines the shared `CentoStorage` layout
- Defines the `Facet` metadata structure
- Provides the core protocol management primitives

**LibBitmap**
- Provides the `bitmap256` value type
- Efficiently tracks routing table occupancy
- Constant-size storage representation with bitmap operations

### Development Utilities

The repository includes:

- `LibDebug` – compile-time debug switch removed from production builds (works with `release` mode configurations).
- `CentoMigrator` – template for implementing protocol-specific storage migrations executed through `IFacetManager.atomicUpdate()`.

---

# Benchmark Methodology

All benchmark values in this README are generated directly from reference implementation contained in this repository using Foundry gas benchmarking tools.

Deployment benchmarks compare complete protocol initialization (router + essential facets).
Upgrade benchmarks compare equivalent multi-facet atomic updates.
Routing benchmarks compare identical protocol calls.

Raw benchmark scripts are available in `test/gas/`. Running the benchmark suite locally should reproduce published values.

---

# Production Readiness

Cento includes complete operational scaffolding:

- **Deployment scripts** with configuration management
- **Upgrade examples** demonstrating atomic facet updates and storage migration
- **Operational tools** (GetFacets, TransferOwnership, CastAdapter) for protocol management
- **Gas benchmarks** validating efficiency claims (first comprehensive benchmarking of both Cento and Diamond ([diamond-2](https://github.com/mudgen/diamond-2-hardhat)))
- **100% test coverage** ensuring production reliability

Developers can fork the reference implementation and deploy a complete modular protocol 
on day one. No selector management boilerplate. No integration decisions to make.

---

# Design Tradeoffs

Every engineering design makes intentional tradeoffs. Cento's design prioritizes upgrade efficiency and operational simplicity over maximizing single-call routing performance.

## Primary Tradeoff: Routing Performance vs. Upgrade Cost

This concerns only protocol-to-protocol calls where append of a single routing byte to calldata happens on-chain, increasing routing cost by approximately **11 gas** (0.2%) compared to Diamond. This is the deliberate design tradeoff that enables:

- **77–87% reduction in upgrade costs** for multi-facet operations
- **43% reduction in protocol deployment costs**
- **Elimination of selector management** from protocol maintenance

For most protocols, upgrade frequency far outweighs call frequency, making this tradeoff strongly favorable. Plus, regular calls where calldata is formed off-chain are cheaper by **25 gas** (0.5%).

## Secondary Constraints

- **Routing table capacity**: 256 facets maximum (sufficient for virtually all protocol architectures)
- **Protocol functions**: Require generated routing wrappers in development (minimal overhead, handled by SDK)

## Operational Advantages

- Eliminates selector management and collision risk
- Dramatically lower deployment and upgrade costs
- Smaller audit and formal verification surface
- Simpler deployment and upgradability for facet management part
- Batch calls benefit from per-facet slot warmups compared to per-selector ones
- Facets may implement custom `receive()` functions

---

# Positioning Relative to ERC-2535 (Diamond Standard)

ERC-2535 pioneered modular smart contract architecture through selector-based routing. Cento preserves this modularity while introducing a fundamental architectural shift:

**Diamond Standard approach**: Function selectors identify facet
- Every function requires selector mapping
- Upgrade cost scales with number of functions modified
- Selector management is permanent operational overhead

**Cento approach**: Routing index identifies facet
- Protocol functions use facet indices (metadata scales with facet count)
- Compatibility standards continue using selectors (no change to existing interfaces)
- Selector management eliminated from protocol development

This pattern does not supersede ERC-2535; it is an **alternative design point** optimizing for upgrade efficiency and operational simplicity. Projects heavily invested in Diamond may prefer to remain on that path. Projects prioritizing low upgrade costs and minimal management overhead should evaluate Cento.

---

# Compatibility Standards

The reference implementation includes native support for:

- **ERC-165**: Interface introspection
- **ERC-173**: Ownership pattern

Additional standards (ERC-20, ERC-721, ERC-1155, etc.) can be implemented as standard compatibility facets, operating through conventional selector-based routing. These will be added in the routing code, locking implementation to specific indices. Plan your ERC support at deployment time.

---

# ERC Proposal

Cento Proxy is proposed as an Ethereum Request for Comments (ERC) standard. The formal specification draft is available in the `erc-XXXX.md` file.

The ERC submission process follows the standardization pathway for core Ethereum protocol extensions. Community discussion and feedback are invited.

---

# Contributing

Issues, discussions, and pull requests are welcome.

**For technical changes:**
- Include benchmark results for architectural or gas-related modifications
- Maintain test coverage for new functionality
- Follow NatSpec documentation standards

**For standards discussion:**
- Reference the ERC specification draft
- Align contributions with proposed standard semantics

---

# Roadmap

The current reference implementation is considered feature complete for the proposed ERC standard.

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

# Author

This example implementation was written by Artem Buchikhin.
If you have questions or would like to discuss Cento - [email me](mailto:artembuchihin@gmail.com).

Contact Info:

- [artembuchihin@gmail.com](mailto:artembuchihin@gmail.com)
- [https://github.com/Arhemius](https://github.com/Arhemius)
- [https://www.linkedin.com/in/artem-buchikhin-215a71241/](https://www.linkedin.com/in/artem-buchikhin-215a71241/)

---

# License

This project is licensed under the MIT License.

See the accompanying `LICENSE` file for details.