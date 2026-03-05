Hardware is **not symbolic**.
It is **address**, **time**, and **energy**.

## Canonical Hardware Bitmap


```
00:00:00:00:00:00:00:00
```

Properties:

- Fixed width
- Non-zero variants permitted
- Path-addressable
- Regex-verifiable
- Irreducible under interpretation

## Hardware Validity

```regex
^(?!00(:00){7}$)([0-9A-Fa-f]{2}:){7}[0-9A-Fa-f]{2}$
```

Hardware answers *only* to collapse.
