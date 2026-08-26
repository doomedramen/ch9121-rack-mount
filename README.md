# CH9121 UART-to-Ethernet Rack Panel Carrier

A rear-mounted 3D-printable **open tray** that holds a CH9121 UART-to-Ethernet
module behind a hand-cut opening in a Raspberry Pi rack fascia. The board's
2×8 pin header stays fully exposed so it can be wired to the Pi's GPIO with
dupont jumpers.

| File | Purpose |
|---|---|
| `ch9121_mount.scad` | Parametric OpenSCAD source. Every dimension is a named variable at the top. |
| `ch9121_carrier.stl` | Printable export. Manifold, genus 3 (RJ45 opening + 2 flange screw holes). |
| `renders/` | `iso.png` (into the tray), `fit.png` (with the module as reference geometry), `flange.png` (front elevation). |

## Design

Open on top, screwed at both ends — no lid, no rails, no snap tab, no glue.

```
        flange (Z 0-4)          open tray (Z 4-48.2)
        +--------+
  RJ45  |  []    |======================\        <- side walls stop 7mm short
  hole  |        |   ribs carry the PCB  |          of the rear so nothing
        +--------+======================/          crowds the dupont housings
         ^      ^
         M3 inserts, screws enter from the front of the panel
```

- **X** = left / right
- **Y** = up / down — **Y = 0 is the top face of the tray floor**
- **Z** = front → back — Z = 0 is the outside face of the flange

Front to back: a 4 mm flange/front-stop slab with the RJ45 cutout and the two
M3 insert bosses, then a U-channel — floor plus two side walls — running back
48.2 mm. Two continuous ribs at the PCB's mounting-hole X positions run the
whole length of the tray and carry the M2.5 inserts the board screws down to.

Overall: **36 × 28 × 48.2 mm**.

### Two sets of brass heat-set inserts

| Where | Size | Bore | Depth | Screw enters from |
|---|---|---|---|---|
| Flange, 2 off at X ±14 | M3 | `flange_insert_d` 4.2 | 5.5 mm | the **front** of the rack panel |
| Tray ribs, 2 off at X ±10.5 | M2.5 | `pcb_insert_d` 3.6 | 4.0 mm | **above**, through the board's own holes |

The flange bores open at the front face and are backed by 2.5 mm bosses on the
rear face, so a standard 5 mm-long M3 insert fits without thickening the whole
flange. Those bosses sit at Y 7.1–15.1, above the tray, so they never foul the
board.

The PCB bores open upward at the seating face, 3 mm above the tray floor. That
3 mm gap plus a 16 mm-wide clear channel down the middle of the tray
(`rib_inner_x` ±8) is what the magjack's heat-staked pegs and RJ45 solder
tails drop into — the board seats on the ribs at X 8.0–12.75 each side and on
nothing else.

## The module

Measured off the seller's dimension drawing and photos:

- PCB **43.0 × 25.5 mm** (the 23 mm figure repeated across listings is wrong)
- RJ45 magjack (HR911105A) overhangs the PCB's front edge by **~4.2 mm**, and
  the front slab is 4.0 mm thick so the connector face lands flush with the
  outside of the flange
- **Two** mounting holes, both near the front corners: X ±10.5, 2.7 mm back
  from the front edge, ~3.0–3.2 mm diameter
- 2×8 header along the rear edge, occupying roughly the last 5 mm

## Still to verify with calipers

Everything below is read off photos, not a datasheet. The `.scad` marks each
one `VERIFY`.

| Variable | Default | What to measure |
|---|---|---|
| `rj45_overhang` | 4.2 | How far the magjack sticks out past the PCB's front edge. **The single most important number** — `front_t` must stay below it or the connector can't reach the panel. |
| `pcb_hole_dx` / `pcb_hole_dz` | 10.5 / 2.7 | Mounting hole centres |
| `pcb_insert_d` | 3.6 (M2.5) | If your holes measure ≥3.3 mm, switch to M3 and set 4.2 |
| `rib_inner_x` | 8.0 | Must clear the widest thing under the magjack |
| `underside_clear` | 2.0 | How far the pegs/tails hang below the PCB |
| `rj45_body_h` | 13.0 | Magjack height **above the PCB top face** — this sets the RJ45 opening's Y position |
| `pcb_t` | 1.6 | PCB thickness |

The model `assert`s its own consistency, so a bad combination fails the render
loudly instead of exporting a part that can't work. Change a variable, re-run,
and if it renders the geometry is self-consistent.

## Printing

- PETG preferred; PLA or ABS/ASA fine.
- **Flange face down on the bed** (the default orientation in the file).
- **No supports needed.** Nothing in the model overhangs in −Z: the tray, the
  ribs and the gussets are all rooted in the flange slab at Z = 4 and grow
  straight up, and the bosses are rectangular rather than round for exactly
  that reason. The only overhangs are the tops of the two M2.5 bores, which
  are 3.6 mm horizontal holes — they bridge fine, and a heat-set insert melts
  through any droop anyway.
- Walls 2.0 mm, floor 2.5 mm, flange 4.0 mm.

## Rebuilding

```bash
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --backend=manifold -o ch9121_carrier.stl ch9121_mount.scad
```

`show_reference = true` adds translucent PCB / magjack / header stand-ins for a
visual fit check. Leave it `false` when exporting.

## Next steps

1. Measure the module and update the `VERIFY` variables.
2. Print a test copy and dry-fit before pressing any inserts in.
3. Cut the fascia opening at 18.0 × 15.5 mm (`rack_hole_w` / `rack_hole_h`),
   plus two M3 clearance holes at 28 mm spacing.
