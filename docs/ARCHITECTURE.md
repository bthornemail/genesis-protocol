# GENESIS Protocol Architecture

This document describes the implemented architecture of the repository and how contributors should reason about evolution.

Important framing:

- This repository is a **multi-project workspace**.
- It is not a single unified runtime today.
- Treat `genesis/`, `genesis-protocol.v1/`, and `genesis-protocol.v2/` as distinct projects with partial overlap.
- See [Project Map](./PROJECT-MAP.md) for strict boundaries.

## 1) Architectural Model

The codebase uses a layered model where lower layers constrain and feed higher layers.

Core idea:

- identity/existence first
- projection/representation second
- structure/validation/projection output last

The repo currently implements this model across three parallel tracks:

- `genesis/`: concrete partial layer implementation (0,2,3,4,7)
- `genesis-protocol.v1/`: most complete shell workflow implementation
- `genesis-protocol.v2/`: complete 0-7 scaffold plus transform libraries

## 2) Layer Responsibilities

### Layer 0 (Observation)

Purpose:

- enumerate filesystem entities
- emit stat-based facts without semantic interpretation

Implemented in:

- `genesis/layer.0/genesis.layer.0.scm`
- `genesis-protocol.v1/genesis-protocol.sh` (`generate`)
- `genesis_bootstrap.sh` (`scan`, `atom`)

### Layer 1 (Selection / Boundary)

Purpose:

- classify files by policy (`include`/`ignore`)
- define light/dark/deferred regions

Implemented in:

- `genesis-protocol.v2/genesis/layer.1/genesis.layer.1.scm`
- `genesis-protocol.v1/genesis-protocol.sh` classification helpers

### Layer 2 (Identity Envelope / Addressing)

Purpose:

- assign deterministic addressing envelope to observed facts
- prepare records for provenance and projection layers

Implemented in:

- `genesis/layer.2/genesis.layer.2.scm` (`addr` vector)
- `genesis-protocol.v2/genesis/layer.2/genesis.layer.2.scm` (placeholder `ip6::path`)

### Layer 3 (Provenance Emission)

Purpose:

- emit appendable provenance views (mainly Org)
- preserve traceability path/class/address/stat

Implemented in:

- `genesis/layer.3/genesis.layer.3.scm`
- `genesis-protocol.v2/genesis/layer.3/genesis.layer.3.scm`
- `genesis-protocol.v1/genesis-protocol.sh` (`contemplate`)

### Layer 4 (Representation)

Purpose:

- wrap bytes/content into deterministic representation envelopes
- separate representation from meaning

Implemented in:

- `genesis/layer.4/genesis.layer.4.scm` (safe read + encoding classification)
- `genesis-protocol.v2/genesis/layer.4/genesis.layer.4.scm`

### Layer 5 (Structure)

Purpose:

- parse representation into structural form (org/json/sexp/bytes)

Implemented in:

- `genesis-protocol.v2/genesis/layer.5/genesis.layer.5.scm` (placeholder AST markers)

### Layer 6 (Schema Gate)

Purpose:

- enforce schema constraints and signature requirements by realm

Implemented in:

- `genesis-protocol.v2/genesis/layer.6/genesis.layer.6.scm` (currently `unknown-schema` placeholder)

### Layer 7 (Judgement / Projection)

Purpose:

- produce VM-visible admissibility/projection state
- enforce reconciliation/judgement over lower-layer facts

Implemented in:

- `genesis/layer.7/genesis.layer.7.scm`
- `genesis/layer.7/genesis.judgement.scm`
- `genesis-protocol.v2/genesis/layer.7/genesis.layer.7.scm`
- `genesis-protocol.v1/genesis-protocol.sh` (`validate`)

## 3) Runtime Surfaces

### Surface A: Bootstrap scanner (top-level)

Entrypoint: `genesis_bootstrap.sh`

Commands:

- `init`
- `scan`
- `atom`
- `view-terms`

Best for:

- quick repository bootstrap
- stat/path atom emission

### Surface B: v1 workflow runtime

Entrypoint: `genesis-protocol.v1/genesis-protocol.sh`

Commands:

- `init`, `generate`, `contemplate`, `interpret`, `translate`, `validate`, `workflow`, `status`

Best for:

- practical full-cycle CLI flow

### Surface C: v2 layer scaffold + transforms

Entrypoints:

- `genesis-protocol.v2/tools/genesis-run.scm` (orchestration scaffold)
- `genesis-protocol.v2/tools/genesis_transform.py`
- `genesis-protocol.v2/tools/genesis-transform.js`
- `genesis-protocol.v2/tools/genesis_transform.h`

Best for:

- extending toward canonical 0-7 Scheme runtime
- geometry/visualization transform integration

## 4) Data Flow

Primary flow:

1. Observe filesystem facts (stat/path)
2. Classify visibility/boundary
3. Assign address/identity envelope
4. Emit provenance views
5. Represent content as typed envelope
6. Parse to structure
7. Validate against schema gate
8. Project admissible VM-visible state

Material artifacts in current code include:

- JSONL observations/atoms
- Org provenance views
- transform outputs (JSONL/CSV/buffer in tool implementations)

## 5) Constitutional Mapping (Metastructure)

As currently encoded:

- constitutional: identity axioms + include/ignore boundaries + gate contracts
- structural: address envelope + transform geometry + provenance nodes
- historical/distributed: append-style observation/provenance records; federation mostly contractual
- observable: Layer 7 projection surfaces and validation endpoints

## 6) Non-Authoritative vs Authoritative Components

Authoritative in practice:

- Layer contracts and repository constraints in `AGENTS.org`
- executable behavior in scripts/modules listed in this doc

Non-authoritative/convenience:

- tangling wrappers (`genesis.sh`, `genesis-protocol.v2/genesis.sh`, `tools/genesis-tangle.sh`)
- orchestration demos/stubs (`tools/genesis-run.scm`)

## 7) Current Architecture Risks

- multiple parallel tracks can drift (`genesis/`, `v1`, `v2`)
- schema gate and structure layers are incomplete in v2
- some command surfaces advertise features not fully wired (v1 `genesis.sh` transform commands)
- Layer 7 judgement/address assumptions differ by track (`addr` vector vs `address` string)

## 8) Recommended Contributor Strategy

1. Choose one target runtime before major feature work.
2. Preserve layer boundaries when implementing missing logic.
3. Keep representation and projection deterministic.
4. Explicitly mark placeholders and keep docs synchronized.
