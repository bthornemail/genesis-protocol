# Project Map: Three Projects in One Repository

This repository should be treated as **three distinct projects** that currently coexist.

## 1) Project Boundaries

## Project A: Root Core + Bootstrap

Primary paths:

- `genesis/`
- `genesis_bootstrap.sh`
- `bin/`
- top-level `genesis.sh` (tangle helper)

Intent:

- concrete low-level layer modules
- stat/path-first observation model
- bootstrap repository seeding and atom scans

Reality:

- concrete layer implementations exist for `0,2,3,4,7`
- missing `1,5,6` in this track
- useful as core substrate, not full standalone pipeline

## Project B: v1 Operational CLI

Primary paths:

- `genesis-protocol.v1/genesis-protocol.sh`
- `genesis-protocol.v1/genesis.sh`
- `genesis-protocol.v1/genesis.scm`
- `genesis-protocol.v1/formal/GenesisTransform.lean`

Intent:

- runnable reference workflow implementing RFC-style commands
- contributor-friendly operational pipeline

Reality:

- most complete end-to-end CLI flow in repo
- includes practical `init/generate/contemplate/interpret/translate/validate/workflow`
- contains inconsistencies (for example help vs dispatch in `genesis.sh` transform commands)

## Project C: v2 Layered Scaffold + Transform Libraries

Primary paths:

- `genesis-protocol.v2/genesis/layer.0` ... `layer.7`
- `genesis-protocol.v2/tools/*`
- `genesis-protocol.v2/genesis.org` (literate source)

Intent:

- canonicalized architecture for 0-7 layer runtime
- typed transform libraries for JS/Python/C consumers
- expansion path toward larger 0-23 conceptual system

Reality:

- full layer directory coverage exists
- several layers are placeholders/stubs
- strongest for architecture direction and integration interfaces, not current runtime completeness

## 2) What Is Authoritative Where

- operational CLI behavior: Project B (`genesis-protocol.v1`)
- concrete layer module behavior in Scheme: Project A (`genesis/`) where implemented
- future architecture shape and transform APIs: Project C (`genesis-protocol.v2`)

If two tracks disagree, do not merge assumptions silently. Document which track a change targets.

## 3) Cross-Track Drift Points

Known drift classes:

- address field shape (`addr` vector vs `address` string)
- layer completeness differences (A partial, C scaffold-complete)
- command surfaces that advertise more than dispatch wiring (B utility script)
- judgement helpers expecting specific layer-2 representation

## 4) Contributor Decision Tree

1. Need working CLI workflow now: use Project B.
2. Need to improve concrete implemented layer logic: use Project A.
3. Need to extend canonical architecture/interfaces for future runtime: use Project C.
4. Need changes affecting more than one project: open with a boundary note and explicit compatibility plan.

## 5) Mandatory PR Header (Recommended)

Include this in every PR description:

- Target project: `A | B | C | A+B | B+C | A+B+C`
- Layer scope: e.g. `L0,L2,L7`
- Compatibility statement: `no cross-track impact` or explicit impact list
- Docs updated: list of docs changed

## 6) Stabilization Path (If You Want One Canonical Runtime)

1. Choose canonical project of record (A, B, or C).
2. Define schema for shared atom/address/projection contracts.
3. Port missing layers into canonical track.
4. Freeze non-canonical tracks as archived/reference.
5. Add contract tests that run the same fixtures across retained surfaces.

Until this is done, treat this repository as a coordinated multi-project workspace, not a single runtime.
