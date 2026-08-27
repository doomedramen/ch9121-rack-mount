# CH9121 UART-to-Ethernet Rack Panel Carrier

A rear-mounted 3D-printable **open tray** that holds a CH9121 UART-to-Ethernet
module behind a hand-cut opening in a Raspberry Pi rack fascia. The board's
2×8 pin header stays fully exposed so it can be wired to the Pi's GPIO with
dupont jumpers.

| File | Purpose |
|---|---|
| `ch9121_mount.scad` | Parametric OpenSCAD source. Every dimension is a named variable at the top. |
| `ch9121_carrier.stl` | Printable export. Manifold, genus 3 (RJ45 opening + 2 flange screw holes). |
| `ch9121_coupon.stl` | **Print this first.** The front 14 mm of the part only — a few minutes on the bed, and it tells you whether the board's screw holes and the magjack actually line up before you commit. |
| `ch9121_fascia_stencil.stl` | 2 mm flat plate for marking the fascia: flange outline, the 17.6 × 15.3 opening, and the two M2 holes. Hold it on the panel, mark or drill through, cut the opening to the line. Symmetric both ways so it can't go on backwards. |
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
         M2 inserts, screws enter from the front of the panel
```

- **X** = left / right
- **Y** = up / down — **Y = 0 is the top face of the tray floor**
- **Z** = front → back — Z = 0 is the outside face of the flange

Front to back: a 4 mm flange/front-stop slab with the RJ45 cutout and the two
M2 insert bosses, then a U-channel — floor plus two side walls — running back
49.3 mm. Two continuous ribs at the PCB's mounting-hole X positions run the
whole length of the tray and carry the M2 inserts the board screws down to.

Overall: **36 × 30 × 49.3 mm**.

### Two sets of brass heat-set inserts

**M2 throughout** — one insert size, one screw, one driver.

| Where | Bore | Depth | Screw enters from |
|---|---|---|---|
| Flange, 2 off at X ±14 | `flange_insert_d` 3.2 | 4.0 mm | the **front** of the rack panel |
| Tray ribs, 2 off at X ±10.16 | `pcb_insert_d` 3.2 | 4.0 mm | **above**, through the board's own holes |

The flange bores open at the front face and are backed by 2.5 mm bosses on the
rear face, giving 6.5 mm of stack for a 4 mm insert without thickening the
whole flange. Those bosses sit at Y 7.7–14.2, clear above the tray, so they
never foul the board.

The PCB bores open upward at the seating face, 3.6 mm above the tray floor —
that height is set by the 3 mm of header solder tail hanging under the board.

Where the board is allowed to touch is driven by what hangs below it. The
magjack's heat-staked pegs and their solder joints span up to ~15.3 mm, so the
seating ribs start at X ±9.6, leaving a 19.2 mm clear channel — 1.95 mm of
margin each side. Only a short pad at each screw position (Z 4–10.4, forward
of the pegs) reaches inboard to ±7.8 to give the M2 bore a 0.76 mm collar.
Under the header the ribs are cut away to the floor entirely, so it makes no
difference exactly where the header pads sit; the board is supported for its
first 33 mm and cantilevers the last 11 mm, which 1 mm FR4 handles fine.

## The module

Measured off the board with calipers. It is an imperial design — 1″ wide,
0.1″ hole inset, 0.1″ header pitch:

| | |
|---|---|
| PCB | **25.4 × 43.18 × 1.0 mm** (1″ × 1.7″) — the 23 mm width repeated across listings is wrong |
| RJ45 magjack (HanRun HR911105A) | 12.7 mm (0.5″) tall above the board, overhangs the front edge by 5.08 mm (0.2″) |
| Mounting holes | Two, at the front corners, **2.54 mm (0.1″) diameter**, centres 2.54 mm (0.1″) in from every edge → X ±10.16, 2.54 back from the front |
| Under the board | 3 mm of solder tail to clear |
| 2×8 header | rear edge, 0.1″ pitch, pins stand 7.62 mm (0.3″) proud |

The magjack overhangs 5.08 mm and the front slab is 4.0 mm, so the connector
face ends up **1.08 mm proud** of the flange and noses into the fascia cut-out.

## Print the coupon first

```bash
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --backend=manifold -o ch9121_coupon.stl -D 'part="coupon"' ch9121_mount.scad
```

It's the front 14 mm of the part — flange, both insert bosses, both flange
screw holes, the RJ45 opening. Sit the board against it and check the two
screw holes line up and the magjack drops into the opening. That's the whole
risk, and it costs a few minutes of filament instead of a two-hour print.

The RJ45 opening started deliberately loose and has been closed up over two
coupon prints. It now sits at **16.8 × 14.5** — 0.4 mm per side on width
(`rj45_clear_x`), 0.9 mm per side on height (`rj45_clear_y`) — and the whole
opening is lifted 1 mm by `rj45_y_trim`, because the connector sits that much
higher than `pcb_top_y + rj45_body_h/2` predicts.

If you ever change `rj45_body_h`, `standoff_h` or `pcb_t`, open both clearances
back out to ~1.5 and re-print the coupon before committing to a full part.

## Still to confirm

| Variable | Default | What to check |
|---|---|---|
| `pcb_insert_d` / `flange_insert_d` | 3.2 | Both are M2. 3.2 suits the common M2×4.0 insert with a 3.2 mm OD, but some M2 inserts want 3.5 — check yours before pressing. |
| `rib_inner_x` | 7.8 | Must clear the magjack's underside pegs (photos put them around ±6.5). |

Everything else is measured. If a number turns out wrong, it's one variable at
the top of the `.scad` — change it, re-run, and the asserts will tell you if
the change broke something else.

The model `assert`s its own consistency, so a bad combination fails the render
loudly instead of exporting a part that can't work. Change a variable, re-run,
and if it renders the geometry is self-consistent.

## Printing

- PETG preferred; PLA or ABS/ASA fine.
- **Flange face down on the bed** (the default orientation in the file).
- **No supports needed.** Nothing in the model overhangs in −Z: the tray, the
  ribs and the gussets are all rooted in the flange slab at Z = 4 and grow
  straight up, and the bosses are rectangular rather than round for exactly
  that reason. The only overhangs are the tops of the two M2 bores, which are
  3.2 mm horizontal holes — they bridge fine, and a heat-set insert melts
  through any droop anyway.
- Walls 2.0 mm, floor 2.5 mm, flange 4.0 mm.

## Rebuilding

```bash
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD --backend=manifold -o ch9121_carrier.stl ch9121_mount.scad
```

`part` selects what gets exported — `"carrier"` (default), `"coupon"` or
`"stencil"`:

```bash
OS=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
$OS --backend=manifold -o ch9121_carrier.stl        ch9121_mount.scad
$OS --backend=manifold -o ch9121_coupon.stl         -D 'part="coupon"'  ch9121_mount.scad
$OS --backend=manifold -o ch9121_fascia_stencil.stl -D 'part="stencil"' ch9121_mount.scad
```

`show_reference = true` adds translucent PCB / magjack / header stand-ins for a
visual fit check. Leave it `false` when exporting.

## Next steps

1. Measure the module and update the `VERIFY` variables.
2. Print a test copy and dry-fit before pressing any inserts in.
3. Print `ch9121_fascia_stencil.stl`, hold it on the panel, mark through it,
   and cut. That's a 17.6 × 15.3 mm opening (`rack_hole_w` / `rack_hole_h`,
   derived from the printed opening plus 0.4 mm per side) plus two M2
   clearance holes at 28 mm spacing. It clears the 1.08 mm of magjack that
   stands proud of the flange with 0.8 mm to spare all round.
