#!/usr/bin/env python3
"""
genesis_transform.py
GENESIS Canonical Transform — Python Implementation
Implements RFC-GENESIS-TRANSFORM-0001
Suitable for: batch processing, data pipeline, tooling
"""

import math
from typing import Dict, List, Any, Tuple, Optional

def fnv1a32(s: str) -> int:
    """
    FNV-1a 32-bit hash for realm index derivation

    Args:
        s: Input string

    Returns:
        32-bit unsigned hash
    """
    h = 0x811c9dc5
    for ch in s:
        h ^= ord(ch)
        h = (h * 0x01000193) & 0xFFFFFFFF
    return h


def class_offset(cls: str) -> float:
    """
    Schema class to vertical offset mapping

    Args:
        cls: "private"|"protected"|"public"

    Returns:
        Y-offset contribution
    """
    return {
        "private": 0.0,
        "protected": 0.25,
        "public": 0.5
    }.get(cls, 0.0)


def genesis_transform(atom: Dict[str, Any], opts: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """
    GENESIS canonical transform: atom → spatial coordinates

    Args:
        atom: GENESIS atom with canonical fields
        opts: Transform parameters (optional)

    Returns:
        {pos: (x,y,z), scale: s, rotY: r, realmIndex: idx}
    """
    opts = opts or {}

    # Extract parameters with defaults
    realm_count = opts.get("realmCount", 8)
    radius = opts.get("radius", 8.0)
    depth_step = opts.get("depthStep", 2.0)
    time_scale = opts.get("timeScale", 0.0000005)
    size_scale = opts.get("sizeScale", 0.001)
    min_scale = opts.get("minScale", 0.3)
    rot_mod = opts.get("rotMod", 360)

    # Realm index (deterministic from realm string)
    realm = atom.get("realm", "")
    realm_idx = fnv1a32(realm) % realm_count
    angle = (realm_idx / realm_count) * math.tau

    # Cylindrical position (X, Z)
    x = math.cos(angle) * radius
    z = math.sin(angle) * radius

    # Extract canonical atom fields
    st = atom.get("stat", {})
    depth = atom.get("depth", 0)
    mtime = st.get("mtime", 0)
    size = st.get("size", 0)
    inode = st.get("inode", 0)

    schema = atom.get("schema", {})
    cls = schema.get("class", "private")

    # Vertical position (Y) = depth + time + schema
    y = (
        depth * depth_step +
        mtime * time_scale +
        class_offset(cls)
    )

    # Logarithmic scale
    s = max(min_scale, math.log(size + 1) * size_scale)

    # Y-axis rotation (from inode)
    rot_y = ((inode % rot_mod) / rot_mod) * math.tau

    return {
        "pos": (x, y, z),
        "scale": s,
        "rotY": rot_y,
        "realmIndex": realm_idx
    }


def to_buffer(transform: Dict[str, Any]) -> List[float]:
    """
    Convert transform to packed Float32 buffer layout

    Args:
        transform: Transform object from genesis_transform()

    Returns:
        [x, y, z, scale, rotY]
    """
    x, y, z = transform["pos"]
    return [x, y, z, transform["scale"], transform["rotY"]]


def geometry_for_role(role: str) -> str:
    """
    Optional: Map role to suggested geometry type
    (Orthogonal to canonical transform)

    Args:
        role: "kernel"|"org"|"source"|"asset"|...

    Returns:
        Geometry hint
    """
    return {
        "kernel": "octahedron",
        "org": "icosahedron",
        "asset": "sphere"
    }.get(role, "box")


def batch_transform(atoms: List[Dict[str, Any]], opts: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
    """
    Batch transform: array of atoms → array of transforms

    Args:
        atoms: List of GENESIS atoms
        opts: Transform parameters

    Returns:
        List of transforms
    """
    return [genesis_transform(atom, opts) for atom in atoms]


def batch_to_buffer(atoms: List[Dict[str, Any]], opts: Optional[Dict[str, Any]] = None) -> List[float]:
    """
    Batch to buffer: atoms → single interleaved float array

    Args:
        atoms: List of GENESIS atoms
        opts: Transform parameters

    Returns:
        Interleaved buffer (5 floats per atom)
    """
    transforms = batch_transform(atoms, opts)
    buffer = []
    for t in transforms:
        buffer.extend(to_buffer(t))
    return buffer


def emit_jsonl(atoms: List[Dict[str, Any]], opts: Optional[Dict[str, Any]] = None) -> str:
    """
    Emit JSONL with transform fields added to each atom

    Args:
        atoms: List of GENESIS atoms
        opts: Transform parameters

    Returns:
        JSONL string (one JSON object per line)
    """
    import json
    lines = []
    for atom in atoms:
        t = genesis_transform(atom, opts)
        enhanced = {**atom, "transform": t}
        lines.append(json.dumps(enhanced))
    return "\n".join(lines)


def emit_csv(atoms: List[Dict[str, Any]], opts: Optional[Dict[str, Any]] = None) -> str:
    """
    Emit CSV with position/scale/rotation columns

    Args:
        atoms: List of GENESIS atoms
        opts: Transform parameters

    Returns:
        CSV string with header
    """
    lines = ["path,realm,x,y,z,scale,rotY,realmIndex"]
    for atom in atoms:
        t = genesis_transform(atom, opts)
        x, y, z = t["pos"]
        path = atom.get("path", "")
        realm = atom.get("realm", "")
        lines.append(
            f"{path},{realm},{x},{y},{z},{t['scale']},{t['rotY']},{t['realmIndex']}"
        )
    return "\n".join(lines)


if __name__ == "__main__":
    # Example usage
    import json
    import sys

    if len(sys.argv) < 2:
        print("Usage: genesis_transform.py <atoms.jsonl> [--csv|--buffer]", file=sys.stderr)
        print("", file=sys.stderr)
        print("Reads GENESIS atoms from JSONL and emits transformed data:", file=sys.stderr)
        print("  (default)  Enhanced JSONL with transform field added", file=sys.stderr)
        print("  --csv      CSV with position/scale/rotation columns", file=sys.stderr)
        print("  --buffer   Raw binary Float32 buffer (5 floats per atom)", file=sys.stderr)
        sys.exit(1)

    input_file = sys.argv[1]
    mode = sys.argv[2] if len(sys.argv) > 2 else "jsonl"

    # Read atoms
    atoms = []
    with open(input_file, 'r') as f:
        for line in f:
            if line.strip():
                atoms.append(json.loads(line))

    # Transform and emit
    if mode == "--csv":
        print(emit_csv(atoms))
    elif mode == "--buffer":
        buffer = batch_to_buffer(atoms)
        # Write binary Float32 to stdout
        import struct
        for val in buffer:
            sys.stdout.buffer.write(struct.pack('f', val))
    else:
        print(emit_jsonl(atoms))
