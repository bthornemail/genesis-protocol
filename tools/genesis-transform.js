// genesis-transform.js
// GENESIS Canonical Transform — JavaScript Implementation
// Implements RFC-GENESIS-TRANSFORM-0001
// Suitable for: Three.js, WebGPU, browser visualization

/**
 * FNV-1a 32-bit hash for realm index derivation
 * @param {string} str - Input string
 * @returns {number} 32-bit unsigned hash
 */
export function fnv1a32(str) {
  let h = 0x811c9dc5;
  for (let i = 0; i < str.length; i++) {
    h ^= str.charCodeAt(i);
    h = Math.imul(h, 0x01000193);
  }
  return h >>> 0;
}

/**
 * Schema class to vertical offset mapping
 * @param {string} cls - "private"|"protected"|"public"
 * @returns {number} Y-offset contribution
 */
export function classOffset(cls) {
  if (cls === "public") return 0.5;
  if (cls === "protected") return 0.25;
  return 0.0; // private/unknown
}

/**
 * GENESIS canonical transform: atom → spatial coordinates
 * @param {Object} atom - GENESIS atom with canonical fields
 * @param {Object} opts - Transform parameters (optional)
 * @returns {Object} {position, scale, rotation, realmIndex}
 */
export function genesisTransform(atom, opts = {}) {
  const {
    realmCount = 8,
    radius = 8,
    depthStep = 2,
    timeScale = 0.0000005,
    sizeScale = 0.001,
    minScale = 0.3,
    rotMod = 360
  } = opts;

  // Realm index (deterministic from realm string)
  const realmIdx = (fnv1a32(atom.realm || "") % realmCount);
  const angle = (realmIdx / realmCount) * Math.PI * 2;

  // Cylindrical position (X, Z)
  const x = Math.cos(angle) * radius;
  const z = Math.sin(angle) * radius;

  // Extract canonical atom fields
  const mtime = Number(atom.stat?.mtime ?? 0);
  const depth = Number(atom.depth ?? 0);
  const size = Number(atom.stat?.size ?? 0);
  const inode = Number(atom.stat?.inode ?? 0);

  // Vertical position (Y) = depth + time + schema
  const y =
    depth * depthStep +
    mtime * timeScale +
    classOffset(atom.schema?.class);

  // Logarithmic scale
  const s = Math.max(minScale, Math.log(size + 1) * sizeScale);

  // Y-axis rotation (from inode)
  const rotY = ((inode % rotMod) / rotMod) * (Math.PI * 2);

  return {
    position: { x, y, z },
    scale: { x: s, y: s, z: s },
    rotation: { x: 0, y: rotY, z: 0 },
    realmIndex: realmIdx
  };
}

/**
 * Convert transform to packed Float32Array buffer
 * Layout: [x, y, z, scale, rotY]
 * @param {Object} t - Transform object
 * @returns {Float32Array} 5-element buffer
 */
export function toBuffer(t) {
  return new Float32Array([
    t.position.x,
    t.position.y,
    t.position.z,
    t.scale.x,
    t.rotation.y
  ]);
}

/**
 * Optional: Map role to suggested geometry type
 * (Orthogonal to canonical transform)
 * @param {string} role - "kernel"|"org"|"source"|"asset"|...
 * @returns {string} Geometry hint
 */
export function geometryForRole(role) {
  switch (role) {
    case "kernel": return "octahedron";
    case "org":    return "icosahedron";
    case "asset":  return "sphere";
    default:       return "box";
  }
}

/**
 * Batch transform: array of atoms → array of transforms
 * @param {Array} atoms - GENESIS atoms
 * @param {Object} opts - Transform parameters
 * @returns {Array} Array of transforms
 */
export function batchTransform(atoms, opts = {}) {
  return atoms.map(atom => genesisTransform(atom, opts));
}

/**
 * Batch to buffer: atoms → single interleaved Float32Array
 * @param {Array} atoms - GENESIS atoms
 * @param {Object} opts - Transform parameters
 * @returns {Float32Array} Interleaved buffer (5 floats per atom)
 */
export function batchToBuffer(atoms, opts = {}) {
  const transforms = batchTransform(atoms, opts);
  const buffer = new Float32Array(transforms.length * 5);

  transforms.forEach((t, i) => {
    const offset = i * 5;
    buffer[offset + 0] = t.position.x;
    buffer[offset + 1] = t.position.y;
    buffer[offset + 2] = t.position.z;
    buffer[offset + 3] = t.scale.x;
    buffer[offset + 4] = t.rotation.y;
  });

  return buffer;
}
