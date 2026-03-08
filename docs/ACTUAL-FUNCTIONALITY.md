# Actual Functionality (Contributor + Developer Guide)

This repository currently contains three parallel code lines:

- `genesis/` + top-level scripts: active core layer modules and bootstrap helpers.
- `genesis-protocol.v1/`: most complete shell workflow implementation.
- `genesis-protocol.v2/`: expanded 0-7 layer scaffold plus transform libraries, but many placeholders.

Contributor warning:

- These should be treated as three different projects living in one repository.
- Do not assume behavior in one track is implemented in the others.
- See [Project Map](./PROJECT-MAP.md) for authority boundaries.

## 1) What Is Runnable Right Now

### A. Top-level bootstrap scanner

File: `genesis_bootstrap.sh`

Working commands:

- `init [DIR]`
- `scan [DIR]` -> JSONL atoms (stat-only)
- `atom PATH` -> one JSON atom
- `view-terms FILE [terms|seps]` -> token/separator projection

Actual behavior:

- Uses `find` + `stat` metadata; does not parse semantics.
- Supports `.genesisinclude` and `.genesisignore` patterns.
- Encodes identity around stat tuple + path binding.

### B. v1 reference workflow (most complete E2E)

File: `genesis-protocol.v1/genesis-protocol.sh`

Working commands:

- `init`
- `generate`
- `contemplate`
- `interpret`
- `translate`
- `validate`
- `workflow`
- `status`

Actual pipeline:

1. Layer 0 generate: file classification + stat observation -> JSONL.
2. Layer 1 contemplate: JSONL -> `.org` projections.
3. Layer 2 interpret: minimal schema read (`realm.default`) and logging.
4. Layer 3 translate: identity or markdown emitters.
5. Layer 7 validate: compares observed count vs current light-file count.

Important implementation notes:

- Classification reads per-directory `.genesisignore`/`.genesisinclude`.
- Validation count in `cmd_validate` uses a `find | while` subshell, so `current_count` remains `0` in many shells.
- `generate` appends observations by default; count output is total lines in file.

### C. v1 combinatorics utility

File: `genesis-protocol.v1/genesis.sh`

Working commands:

- `probe`
- `compile`
- `decompile`
- `translate`
- `mux8`

Declared but not dispatch-wired:

- `emit-transform-jsonl`
- `emit-transform-csv`
- `emit-transform-buffer`

These functions exist in the script but are missing from the final `case` dispatch, so invoking them currently returns `unknown command`.

### D. Tangling entrypoints

Files:

- `genesis.sh` (repo root)
- `genesis-protocol.v2/genesis.sh`
- `genesis-protocol.v2/tools/genesis-tangle.sh`

Behavior:

- Batch-tangle `genesis.org` via Emacs Org Babel.
- These are generation helpers, not full runtime pipeline drivers.

## 2) Layer Implementations by Code Line

## Top-level `genesis/` modules

Implemented modules:

- `layer.0`: concrete Guile enumeration + `stat` facts (`L0.enumerate`, `L0.stat`)
- `layer.2`: deterministic IPv6-like 8-byte address vector assignment (`L2.assign`)
- `layer.3`: org provenance subtree emitter (`L3.emit-org`)
- `layer.4`: representation wrapper + safe byte read with UTF-8/binary/truncated handling (`L4.represent`)
- `layer.7`: residue policy projection (`L7.project`) and judgement file (`L7.judge`)

Not present in this code line:

- `layer.1`, `layer.5`, `layer.6` source files

Consequence:

- The top-level `genesis/` tree is a partially materialized core, not a standalone full 0-7 pipeline.

## `genesis-protocol.v2/genesis/` modules

Implemented as scaffold (0-7 all present):

- `layer.0`: placeholder enumerate/stat
- `layer.1`: include/ignore classification (`unknown-unknown`, `known-unknown`, `known-known`)
- `layer.2`: placeholder `ip6::path` addressing and visibility envelope
- `layer.3`: basic org provenance emitter
- `layer.4`: representation wrapper using injected read function
- `layer.5`: structure parser stubs (`org/json/sexp/bytes` placeholders)
- `layer.6`: schema gate placeholder (`unknown-schema`)
- `layer.7`: deterministic residue, admissibility, parity/prime facets projection

Consequence:

- v2 expresses intended architecture end-to-end, but several layers are intentionally non-final placeholders.

## 3) Data Contracts in Use

### Observation (v1 workflow)

`generate` emits JSONL records with:

- `ts`
- `atom` (alnum-only path collapse)
- `path`
- `stat.{dev,ino,mode,uid,gid,size,atime,mtime,ctime}`

### Atom (bootstrap scanner)

`genesis_bootstrap.sh scan` emits JSONL with:

- `t`
- `k="genesis.atom"`
- `v.path`
- `v.stat.{dev,ino,mode,uid,gid,size,atime,mtime,ctime}`

### v1 combinatorics probe

`genesis-protocol.v1/genesis.sh probe` emits JSONL with:

- timestamp/path/id/stat
- `hw`: 8-byte hardware fingerprint view
- `v`: 8-int software topology vector

## 4) Transform / Geometry Functionality

Canonical transform implementations exist in v2 tools:

- `genesis-protocol.v2/tools/genesis-transform.js`
- `genesis-protocol.v2/tools/genesis_transform.py`
- `genesis-protocol.v2/tools/genesis_transform.h`

Shared behavior:

- Deterministic realm bucket via FNV-1a hash.
- Cylindrical X/Z positioning by realm index.
- Y from depth + mtime + schema class offset.
- Log scale from file size.
- Rotation from inode.
- Buffer packing (`[x,y,z,scale,rotY]`).

## 5) Repository Reality vs Architectural Contract

The AGENTS architecture describes larger ranges (0-23) and strict layer contracts. Current code reality is:

- 0-7 semantics are the active implementation target.
- 8-23 are documented conceptually, not implemented in this repo.
- The most operational CLI today is under `genesis-protocol.v1/`.
- v2 provides the clearer structural model for future completion.

## 6) Contributor Workflow (Practical)

1. Use `genesis-protocol.v1/genesis-protocol.sh` when you need a working shell workflow.
2. Use top-level `genesis/` modules when refining concrete Guile layer behavior.
3. Use `genesis-protocol.v2/` when extending the architectural scaffold toward full 0-7 completion.
4. Keep docs and code honest: mark placeholders explicitly and avoid presenting scaffold code as complete logic.

## 7) Known Gaps / Risks

- Root `README.md` is empty; docs live mostly outside root onboarding.
- Top-level and v2 layer trees diverge (concrete vs placeholder coverage).
- v1 `genesis.sh` exposes transform commands in help text but does not route them in command dispatch.
- Layer judgement modules call `L2.addr->hex`/`addr` assumptions that differ between code lines (`address` string vs `addr` vector).

Use these as contribution entry points when stabilizing a single canonical runtime.
