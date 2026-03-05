/* genesis_transform.h
 * GENESIS Canonical Transform — Portable C Implementation
 * Implements RFC-GENESIS-TRANSFORM-0001
 * Suitable for: POSIX systems, native performance, GPU upload
 */

#pragma once

#include <stdint.h>
#include <math.h>
#include <string.h>

/* POSIX stat fields (subset needed for transform) */
typedef struct {
  uint64_t size;
  uint64_t mtime;
  uint64_t inode;
} GenesisStat;

/* Canonical GENESIS atom (minimal fields for transform) */
typedef struct {
  const char *path;
  const char *realm;
  uint32_t depth;
  const char *role;
  const char *schema_class;  /* "private"|"protected"|"public" */
  GenesisStat stat;
} GenesisAtom;

/* Transform output */
typedef struct {
  float x, y, z;
  float scale;
  float rotY;
  uint32_t realmIndex;
} GenesisTransform;

/* Transform parameters */
typedef struct {
  uint32_t realmCount;
  float radius;
  float depthStep;
  float timeScale;
  float sizeScale;
  float minScale;
  uint32_t rotMod;
} GenesisTransformParams;

/* Default parameters (matches RFC spec) */
static inline GenesisTransformParams genesis_default_params(void) {
  GenesisTransformParams p = {
    .realmCount = 8,
    .radius = 8.0f,
    .depthStep = 2.0f,
    .timeScale = 0.0000005f,
    .sizeScale = 0.001f,
    .minScale = 0.3f,
    .rotMod = 360
  };
  return p;
}

/* FNV-1a 32-bit hash (for realm index derivation) */
static inline uint32_t fnv1a32(const char *s) {
  if (!s) return 0x811c9dc5u;
  uint32_t h = 0x811c9dc5u;
  for (; *s; s++) {
    h ^= (uint8_t)(*s);
    h *= 0x01000193u;
  }
  return h;
}

/* Schema class to vertical offset mapping */
static inline float class_offset(const char *cls) {
  if (!cls) return 0.0f;

  /* Fast path: check first two chars */
  if (cls[0] == 'p' && cls[1] == 'u') return 0.5f;  /* public */
  if (cls[0] == 'p' && cls[1] == 'r') {
    /* Could be "private" or "protected" */
    if (cls[2] == 'i') return 0.0f;  /* private */
    if (cls[2] == 'o') return 0.25f; /* protected */
  }

  return 0.0f;  /* default to private */
}

/* Main transform: atom + params → spatial coordinates */
static inline GenesisTransform genesis_transform(
  const GenesisAtom *atom,
  const GenesisTransformParams *params
) {
  GenesisTransform t;

  /* Realm index (deterministic from realm string) */
  uint32_t h = fnv1a32(atom->realm);
  t.realmIndex = (params->realmCount == 0) ? 0 : (h % params->realmCount);

  /* Cylindrical position (X, Z) */
  float angle = ((float)t.realmIndex / (float)params->realmCount) * (float)(M_PI * 2.0);
  t.x = cosf(angle) * params->radius;
  t.z = sinf(angle) * params->radius;

  /* Vertical position (Y) = depth + time + schema */
  float y_depth = (float)atom->depth * params->depthStep;
  float y_time = (float)atom->stat.mtime * params->timeScale;
  float y_class = class_offset(atom->schema_class);
  t.y = y_depth + y_time + y_class;

  /* Logarithmic scale */
  float s = logf((float)atom->stat.size + 1.0f) * params->sizeScale;
  t.scale = (s < params->minScale) ? params->minScale : s;

  /* Y-axis rotation (from inode) */
  uint32_t m = (params->rotMod == 0) ? 360 : params->rotMod;
  t.rotY = ((float)(atom->stat.inode % m) / (float)m) * (float)(M_PI * 2.0);

  return t;
}

/* Pack transform into Float32 buffer: [x, y, z, scale, rotY] */
static inline void genesis_to_buffer(const GenesisTransform *t, float out[5]) {
  out[0] = t->x;
  out[1] = t->y;
  out[2] = t->z;
  out[3] = t->scale;
  out[4] = t->rotY;
}

/* Optional: role → geometry hint (orthogonal to transform) */
typedef enum {
  GENESIS_GEOM_BOX = 0,
  GENESIS_GEOM_OCTAHEDRON,
  GENESIS_GEOM_ICOSAHEDRON,
  GENESIS_GEOM_SPHERE
} GenesisGeometry;

static inline GenesisGeometry genesis_geometry_for_role(const char *role) {
  if (!role) return GENESIS_GEOM_BOX;

  switch (role[0]) {
    case 'k':  /* kernel */
      if (strcmp(role, "kernel") == 0) return GENESIS_GEOM_OCTAHEDRON;
      break;
    case 'o':  /* org */
      if (strcmp(role, "org") == 0) return GENESIS_GEOM_ICOSAHEDRON;
      break;
    case 'a':  /* asset */
      if (strcmp(role, "asset") == 0) return GENESIS_GEOM_SPHERE;
      break;
  }

  return GENESIS_GEOM_BOX;
}

/* Batch transform: array of atoms → array of transforms */
static inline void genesis_batch_transform(
  const GenesisAtom *atoms,
  uint32_t count,
  const GenesisTransformParams *params,
  GenesisTransform *out_transforms
) {
  for (uint32_t i = 0; i < count; i++) {
    out_transforms[i] = genesis_transform(&atoms[i], params);
  }
}

/* Batch to buffer: atoms → single interleaved Float32 array */
static inline void genesis_batch_to_buffer(
  const GenesisAtom *atoms,
  uint32_t count,
  const GenesisTransformParams *params,
  float *out_buffer  /* must have space for count * 5 floats */
) {
  for (uint32_t i = 0; i < count; i++) {
    GenesisTransform t = genesis_transform(&atoms[i], params);
    genesis_to_buffer(&t, &out_buffer[i * 5]);
  }
}
