# Contributor Boundaries

This repository contains three projects. Contributors must declare scope before changing code.

## Scope Declaration

State at top of your change/PR:

- target project: `A (root core)`, `B (v1 workflow)`, `C (v2 scaffold)`
- target layers: e.g. `0,2,3`
- whether cross-project sync is required

## Boundary Rules

1. Do not copy behavior between projects without documenting semantic differences.
2. Do not call v2 scaffold code "complete" unless placeholders are replaced.
3. Do not change v1 CLI contracts without updating docs and help text together.
4. Do not change layer data shapes (`addr`/`address`, record fields) without migration notes.
5. Keep generated/tangled outputs and source-of-truth files consistent.

## Minimal Test Expectations by Project

- Project A: verify module load and layer function behavior for touched layers.
- Project B: run script help + touched command path smoke tests.
- Project C: verify touched scaffold/transform tool behavior and outputs.

## Docs to Update for Any Behavior Change

- `docs/ACTUAL-FUNCTIONALITY.md`
- `docs/ARCHITECTURE.md`
- `docs/PROJECT-MAP.md`
- `docs/INDEX.md` (if navigation changed)
- `docs/GLOSSARY.md` (if terms/contracts changed)
