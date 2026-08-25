#!/usr/bin/env python3
"""Generate Slate's app icon from the design palette. Stdlib only.

Art: slate-blue ground, a paper-colored rounded page with three rules —
an echo of the empty-state glyph. Regenerate with:
    python3 Tools/make_icon.py App/Assets.xcassets/AppIcon.appiconset/icon-1024.png
"""
import struct
import sys
import zlib

SIZE = 1024
SS = 3  # supersample factor for smooth corners

GROUND = (0x4E, 0x5D, 0x78)
PAPER = (0xF7, 0xF6, 0xF3)
RULE = (0x4E, 0x5D, 0x78)


def rounded_rect_coverage(x, y, left, top, right, bottom, radius):
    """1.0 inside the rounded rect, 0.0 outside (evaluated at sample centres)."""
    if x < left or x > right or y < top or y > bottom:
        return False
    for cx, cy in (
        (left + radius, top + radius),
        (right - radius, top + radius),
        (left + radius, bottom - radius),
        (right - radius, bottom - radius),
    ):
        in_x = x < cx if cx == left + radius else x > cx
        in_y = y < cy if cy == top + radius else y > cy
        if in_x and in_y:
            return (x - cx) ** 2 + (y - cy) ** 2 <= radius ** 2
    return True


def render():
    w = h = SIZE
    # Page geometry, centred.
    page_w, page_h, page_r = 520, 660, 44
    left = (w - page_w) / 2
    top = (h - page_h) / 2
    right = left + page_w
    bottom = top + page_h

    rules = []
    rule_h, rule_r = 26, 13
    rule_left = left + 84
    for i, width in enumerate((352, 352, 220)):
        ry = top + 190 + i * 104
        rules.append((rule_left, ry, rule_left + width, ry + rule_h, rule_r))

    rows = []
    inv = 1.0 / (SS * SS)
    for py in range(h):
        row = bytearray()
        for px in range(w):
            page_hits = 0
            rule_hits = 0
            for sy in range(SS):
                y = py + (sy + 0.5) / SS
                for sx in range(SS):
                    x = px + (sx + 0.5) / SS
                    if rounded_rect_coverage(x, y, left, top, right, bottom, page_r):
                        page_hits += 1
                        for rl, rt, rr, rb, rr_r in rules:
                            if rounded_rect_coverage(x, y, rl, rt, rr, rb, rr_r):
                                rule_hits += 1
                                break
            page_a = page_hits * inv
            rule_a = rule_hits * inv
            r = GROUND[0] * (1 - page_a) + PAPER[0] * page_a
            g = GROUND[1] * (1 - page_a) + PAPER[1] * page_a
            b = GROUND[2] * (1 - page_a) + PAPER[2] * page_a
            r = r * (1 - rule_a) + RULE[0] * rule_a
            g = g * (1 - rule_a) + RULE[1] * rule_a
            b = b * (1 - rule_a) + RULE[2] * rule_a
            row += bytes((int(r + 0.5), int(g + 0.5), int(b + 0.5)))
        rows.append(bytes([0]) + bytes(row))
    return w, h, b"".join(rows)


def chunk(tag, data):
    return (struct.pack(">I", len(data)) + tag + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF))


def write_png(path, w, h, raw):
    header = struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0)
    png = (b"\x89PNG\r\n\x1a\n"
           + chunk(b"IHDR", header)
           + chunk(b"IDAT", zlib.compress(raw, 9))
           + chunk(b"IEND", b""))
    with open(path, "wb") as f:
        f.write(png)


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "icon-1024.png"
    width, height, raw = render()
    write_png(out, width, height, raw)
    print(f"wrote {out}")
