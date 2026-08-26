# CH9121 UART-to-Ethernet Rack Panel Carrier

A rear-mounted 3D-printable carrier that holds a CH9121 UART-to-Ethernet
module behind a hand-cut opening in an existing Raspberry Pi rack fascia.
Built from the design spec in this project; see `ch9121_mount.scad` for the
full parametric source.

## Files

| File | Purpose |
|---|---|
| `ch9121_mount.scad` | Parametric OpenSCAD source. Every dimension is a named variable at the top of the file. |
| `ch9121_carrier.stl` | Printable export (reference geometry / fit-check boxes excluded). |
| `renders/` | Preview images (isometric, flange face, internal cross-section). |

## How the part is built

Print orientation matches the spec's recommendation: the **flange (glue
face) sits flat on the print bed**, and the carrier body extends upward.
In the model's own coordinate system:

- **X** = left / right (flange width)
- **Y** = up / down (flange height)
- **Z** = front → back (Z=0 is the exterior glue face; +Z runs back toward
  the Raspberry Pi)

Structure, front to back:

1. **Flange** (Z 0–3mm) — flat glue face against the rear of the rack fascia.
2. **Front-stop slab** (Z 3–6mm) — solid except for the RJ45 opening; this
   is what the RJ45/PCB butts up against, and it also gives the M3 bosses
   their full 6mm depth without any extra material.
3. **Rail tube** (Z 6–50mm) — hollow channel with grooved rails on the left
   and right inner walls that the PCB slides down into from the open top.
4. **Snap tab** — a small cantilever near the open end that catches the
   PCB's rear edge so it can't slide out backward when a cable is unplugged.

## Rough dimensions used (see spec for full detail)

- Module envelope: 43 × 23 × 14.5 mm (widely repeated across sellers —
  confirmed by search)
- RJ45 carrier opening: 17.0 × 14.5 mm, corner radius 0.8mm
- Rack hand-cut opening (not printed): 18 × 15.5 mm
- Flange: 36 × 28 × 3 mm
- PCB cavity: 23.6 mm wide × 15.5 mm tall, 44mm usable channel length
- M3 mounting: 2-hole variant, ±14mm on X, 3.4mm clearance / 4.2mm insert bore

## What's still a rough guess — verify before a final print

These couldn't be pinned down from any datasheet or seller listing (none
publish a mechanical drawing of the assembled board), so they're set to
sensible centered defaults and flagged as variables in the `.scad` file:

- `rj45_y_offset` — vertical position of the RJ45 body relative to the PCB
  centerline (default: centered)
- `pcb_rail_y` — vertical position of the PCB itself within the cavity
  (default: centered)
- `rj45_setback` — how far the RJ45 front face sits back from the PCB's
  front edge (default: 0 / flush)

**Also worth double-checking:** one seller (chinalctech) lists a CH9121
module variant at **50 × 25 mm** rather than 43 × 23 mm — a meaningfully
different footprint. Confirm which size your actual board is before
committing to a final print; the cavity/flange numbers above assume the
43 × 23 × 14.5mm version.

Fastest way to nail these down: photograph your module from the top and
the side next to a ruler/graph paper, or just measure with calipers —
then update the handful of variables at the top of the .scad file and
re-export.

## Printing notes

- Recommended material: PETG (preferred), PLA or ABS/ASA also fine.
- Print with the flange face-down on the bed (default orientation in the
  file) — gives a flat, support-free glue surface.
- Minimum wall thickness used: 2.0mm; flange 3.0mm.
- No supports should be needed in this orientation.

## Next steps

1. Measure your actual module (calipers or photo-against-graph-paper) and
   adjust `rj45_y_offset`, `pcb_rail_y`, `rj45_setback` if needed.
2. Print a test copy and dry-fit the module before gluing.
3. Confirm heat-set insert size against `m3_insert_d` (currently 4.2mm)
   if using the M3 mounting option.
