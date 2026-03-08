# GENESIS Glossary

## Atom

A normalized identity record emitted from filesystem observation, typically carrying path and stat fields. In several flows, atom identity is alphanumeric-collapsed from path.

## Admissibility

Layer 7 policy outcome determining whether a projected state is allowed to appear on execution/VM surfaces.

## Address Envelope

Layer 2 identity wrapper that locates/organizes observed entities for later layers. Implemented as `addr` vector in top-level modules and `address` string scaffold in v2.

## BICF (Boundary / Interaction Constraint Field)

Repository boundary model for how entities may interact across visibility classes and layers. In code, approximated today by include/ignore classification and schema-gate intent.

## Class Boundary

The `unknown-unknown`, `known-unknown`, `known-known` partition used by classifiers.

## Contemplate

v1 command that projects observation JSONL into `.org` view files (Layer 1-style projection surface).

## Deferred Content

Representation state where identity/path are known but full content parsing or semantic materialization is intentionally postponed.

## Federation

Multi-agent/distributed semantics layer in the architecture. Mostly conceptual in current codebase; not a complete distributed protocol implementation yet.

## Gate

Layer 6 validation checkpoint for schema, signatures, and realm constraints before final projection.

## Genesis Layer

A numbered stage in the protocol pipeline. Active implementation focus is Layers 0-7 in this repository.

## Hypergraph Organization

Structural interpretation where entities and relations form higher-order connectivity. Present as architectural intent; explicit runtime hypergraph data structures are not yet materialized.

## Identity (Alnum Collapse)

Normalization rule where non-alphanumeric separators are treated as view syntax, not canonical identity characters.

## Include / Ignore

Pattern-based repository controls (`.genesisinclude`, `.genesisignore`) that define visibility classes and observation eligibility.

## Judgement

Layer 7 reconciliation over prior-layer outputs to produce accept/warn/reject style outcomes.

## Known-Known (KK)

File/entity class considered explicitly visible (light) under include/ignore policy.

## Known-Unknown (KU)

File/entity class recognized but not yet fully admitted or interpreted.

## Layer 0 Observation

Filesystem fact capture based on stat/path metadata without semantic parsing.

## Layer 3 Provenance

Appendable origin/history representation emitted as Org-compatible nodes and properties.

## Logic Ladder

Conceptual progression from propositional through higher-order/constraint/rule-engine forms. In this repo it is treated as payload over a stable metastructure, not as separate competing foundations.

## Metastructure

The invariant layer-constitution that logical payloads inhabit (constitutional, structural, historical/distributed, observable).

## Projection Surface

Developer/user-visible output view generated from adjudicated lower-layer facts (for example Layer 7 VM-facing records, translated artifacts).

## Realm

Policy domain used for classification/gating/transform bucketing. In transforms, realm hashes to deterministic spatial partitions.

## Residue

Layer 7 reduced index (often modulo domain) used for projection policy and facet derivation.

## Schema

Constraint declaration used by interpretation/gate layers to enforce admissibility contracts.

## Separator View

Non-alphanumeric symbols treated as view grammar rather than identity-bearing core symbols.

## Transform (Canonical GENESIS Transform)

Deterministic mapping from atom fields to geometric coordinates and render metadata (`x,y,z,scale,rotY,realmIndex`).

## Unknown-Unknown (UU)

File/entity class intentionally dark or excluded by policy.

## VM-Visible State

Final projected state exposed to runtime/consumer layers after judgement/admissibility checks.
