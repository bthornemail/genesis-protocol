# Logic Ladder and Seven-Invariant Metastructure

This document maps the conceptual logic progression to what is currently implemented.

## 1) Logic Ladder (Conceptual)

Progression discussed for this project space:

- propositional logic
- first-order logic
- second-order logic
- higher-order logic
- grammar/logical syntax systems
- concurrent constraint logic
- rule engines

Current status in code:

- The repository does not implement formal theorem provers for each rung.
- Instead, it implements a layered **operational substrate** where those logical orders can be hosted.
- This matches the statement: seven invariants are metastructure, not alternatives to logic.

## 2) Seven-Invariant Metastructure Mapping

### Constitutional basis

#### Type theory / axioms anchor admissibility

Implemented traces:

- Identity constraints: alnum-collapse and stat/path anchoring (`genesis-protocol.v1/genesis-protocol.sh`, `genesis_bootstrap.sh`).
- Layer contracts and non-negotiable rules in `AGENTS.org`.

#### Boundaries / BICF / constraints govern interaction

Implemented traces:

- Include/ignore class boundary (`known-known`, `known-unknown`, `unknown-unknown`) in v1 and v2 classifiers.
- Layer 6 gate exists in v2 but currently returns `unknown-schema` placeholder.

### Structural basis

#### Geometry gives continuity / duality / dimension

Implemented traces:

- Canonical transform in JS/Python/C header (`genesis-protocol.v2/tools/*transform*`) maps atoms into deterministic spatial coordinates.

#### Hypergraph gives structural organization

Implemented traces:

- Addressing and envelope concepts in Layer 2 (`addr` vector in top-level; `address` string scaffold in v2).
- Provenance nodes and property linking in Layer 3 Org emitters.

Limit:

- No explicit hypergraph runtime data structure is materialized yet.

### Historical / distributed basis

#### Provenance gives temporalized lawful composition

Implemented traces:

- Layer 3 emitters capture path/class/address/stat facts into appendable Org projections.
- Observation logs are JSONL append-style records.

#### Federation gives multi-agent distributed semantics

Implemented traces:

- Conceptual contracts for multi-agent behavior are documented in AGENTS.

Limit:

- No distributed consensus/federation protocol implementation is present in executable code.

### Observable basis

#### Projection gives observable execution surfaces

Implemented traces:

- Layer 7 projection functions (residue/admissibility/facets) produce VM-visible state records.
- `translate`/projection commands in shell workflows expose human/artifact outputs.

## 3) Practical Interpretation for Contributors

The correct way to work in this repository today:

- Treat the seven invariants as interface contracts across layers.
- Treat logic-rung features as **future payloads** that must fit these contracts.
- Keep distinction explicit between:
  - implemented invariants plumbing
  - conceptual logic payloads not yet encoded.

## 4) Development Rule of Thumb

When adding new logic (rules, constraints, theorem checks, grammar engines):

1. Anchor identity/provenance in Layers 0-3 first.
2. Add representation/structure/gate in Layers 4-6.
3. Expose only adjudicated state via Layer 7 projection.
4. Do not bypass layer contracts even for experimental features.
