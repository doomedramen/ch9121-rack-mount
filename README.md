# CH9121 UART-to-Ethernet Rack Panel Carrier

> **Also in this repo:** [`pi5_ch9121_1u.scad`](pi5_ch9121_1u.scad) — a 1U
> 10-inch rack panel that holds one Raspberry Pi 5 and this carrier. See
> [the panel section](#1u-panel-raspberry-pi-5--carrier) at the bottom.

A rear-mounted 3D-printable **open tray** that holds a CH9121 UART-to-Ethernet
module behind a hand-cut opening in a Raspberry Pi rack fascia. The board's
2×8 pin header stays fully exposed so it can be wired to the Pi's GPIO with
dupont jumpers.

| File | Purpose |
|---|---|
| `ch9121_mount.scad` | Parametric OpenSCAD source. Every dimension is a named variable at the top. |
| `ch9121_carrier.stl` | Printable export. Manifold, genus 5 (RJ45 opening, 2 flange bores, 2 board bores). |
| `ch9121_coupon.stl` | **Print this first.** The front 14 mm of the part only — a few minutes on the bed. Checks that the board's screw holes and the magjack line up, and lets you test-press an insert before committing. |
| `ch9121_fascia_stencil.stl` | 2 mm flat plate for marking the fascia: flange outline, the 17.6 × 15.3 opening, and the two M2 holes. Hold it on the panel, mark or drill through, cut the opening to the line. Symmetric both ways so it can't go on backwards. |
| `renders/` | `iso.png` (into the tray), `fit.png` (module shown as reference geometry), `flange.png` (front elevation), `underside.png` (insert bores), `stencil.png`. |

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
48.2 mm. Two continuous ribs at the PCB's mounting-hole X positions run the
whole length of the tray and carry the M2 inserts the board screws down to.

Overall: **36 × 30 × 48.2 mm**.

### Two sets of brass heat-set inserts

**M2 throughout** — one insert size, one screw, one driver.

| Where | Bore | Depth | Screw enters from |
|---|---|---|---|
| Flange, 2 off at X ±14 | `flange_insert_d` 3.2 | 4.0 mm | the **front** of the rack panel |
| Tray ribs, 2 off at X ±10.16 | `pcb_insert_d` 3.2 | 4.0 mm | **above**, through the board's own holes (insert itself presses in from the tray *underside* — see below) |

The flange bores open at the front face and are backed by 2.5 mm bosses on the
rear face, giving 6.5 mm of stack for a 4 mm insert without thickening the
whole flange. Those bosses sit at Y 7.7–14.2, clear above the tray, so they
never foul the board.

The PCB bores open **downward, at the underside of the tray floor**, and the
insert is pressed in from there. It cannot go in from above: the bore mouth
sits 2.54 mm behind a flange that stands ~23 mm proud of the tray floor, and a
soldering iron's barrel fouls the flange long before the tip seats. The
underside is a flat open face with the flange protruding only 0.55 mm past it.
The screw then passes down through the board and a 2.4 mm clearance section to
reach the insert below — M2×6 gives 2.9 mm of engagement in the 4 mm insert
and still clears the tray bottom by 1.1 mm.

Those bores are cut in `pcb_screw_holes()` at **assembly level**, not inside
`pcb_rails()`. The tray floor is a separate solid, so subtracting them from the
ribs alone leaves the floor plugging the bottom of every bore — which is
exactly what happened, and is why the exported genus is worth checking (5:
RJ45 opening, two flange bores, two board through-holes).

Where the board is allowed to touch is driven by what hangs below it. The
magjack's heat-staked pegs and their solder joints span up to ~15.3 mm, so the
seating ribs start at X ±9.6, leaving a 19.2 mm clear channel — 1.95 mm of
margin each side. Only a short pad at each screw position (Z 4–9.3, forward
of the pegs) reaches inboard to ±7.8 to give the M2 bore a 0.76 mm collar.
Under the header the ribs are cut away to the floor entirely, so it makes no
difference exactly where the header pads sit; the board is supported for its
first 32 mm and cantilevers the last 11 mm, which 1 mm FR4 handles fine.

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

The board is pushed forward until its front edge butts the back face of the
flange slab at Z = 4.0 — that is its only hard stop, so it is where the board
actually sits. The magjack overhangs 5.08 mm against a 4.0 mm slab, so the
connector face ends up **1.08 mm proud** of the flange and noses into the
fascia cut-out. Screw positions are measured from that seated position, so
`pcb_front_z` must equal `front_t`; there is an assert on it.

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

## Hardware

| | |
|---|---|
| Inserts | 4 × M2 heat-set, **4.0 mm long, 3.2 mm OD**. One size covers both bores. |
| Screws | 4 × **M2×6 button head**. Length is measured under the head, so it is 6 mm of penetration at both ends. |

Button head rather than countersunk on the board: the PCB's holes are
plain-drilled, so a conical head cannot seat — it bears on a 1.27 mm rim of
FR4 and wedges. Countersunk would be fine on the flange (flush panel) but then
you would have to countersink the fascia by hand, and button head costs only
~1.1 mm of head standing proud.

**Do not use M2×8 on the board** — 7 mm of penetration against 6.1 mm of
material punches through the tray floor. M2×8 is fine on the flange if your
fascia is thicker than ~3 mm; the relief bore runs right through, so the tip
just enters open air behind.

## Assembly order

1. Print `ch9121_coupon.stl`. Check the screw holes line up, the magjack drops
   into the opening, and an insert presses in cleanly.
2. Print `ch9121_carrier.stl` and `ch9121_fascia_stencil.stl`.
3. **Dry-fit the board before pressing any inserts.** They do not come out.
4. Press the two board inserts in from the **tray underside**, and the two
   flange inserts in from the **front face**. Seat each a hair below flush —
   proud stops the part sitting flat, and on the flange it holds the carrier
   off the panel. Scrape back any ridge of displaced plastic.
5. Hold the stencil on the fascia, mark through it, cut. That is a
   17.6 × 15.3 mm opening (`rack_hole_w` / `rack_hole_h`, the printed opening
   plus 0.4 mm per side) plus two M2 clearance holes at 28 mm spacing. It
   clears the 1.08 mm of magjack standing proud of the flange with 0.8 mm to
   spare all round.
6. Screw the carrier to the fascia, then the board into the tray.

---

## 1U panel: Raspberry Pi 5 + carrier

`pi5_ch9121_1u.scad` is a 254 × 44.5 mm 10-inch-rack 1U panel adapted from the
reference mounts in `pi_references/`. **The carrier is part of the print**: the
panel `include`s `ch9121_mount.scad` and unions `ch9121_carrier()` onto the
back of the fascia, flange face flush with the panel front. The carrier's two
flange screws and bosses are dropped (`include_flange_screws = false`) — there
is nothing to screw to when the flange grows out of the panel — and the fascia
carries the carrier's own test-fitted 16.8 × 14.5 opening rather than the
looser hand-cut stencil hole. All carrier dimensions stay in
`ch9121_mount.scad`; there is one source of truth.

| File | Purpose |
|---|---|
| `pi5_ch9121_1u.scad` | Parametric source. Pi 5 dimensions verified against the official mechanical drawing. |
| `pi5_ch9121_1u.stl` | The panel. Manifold, genus 8 (4 ear slots, Pi port opening, RJ45 tunnel, 2 carrier board bores). |
| `pi5_ch9121_1u_coupon.stl` | Front 14 mm slice — checks the Pi port opening and the CH9121 board alignment before a full print. |
| `renders/panel_*.png` | `iso`, `fit` (Pi / cooler / adapter / CH9121 ghosts), `front`. |

**Layout, viewed from the front, left → right:**

1. **Open cable bay** (~110 mm) — the Pi's USB-C power and micro-HDMI → HDMI
   adapter exit sideways into this space. The adapter plus a mated full-size
   HDMI plug needs ~75 mm; there is ~110.
2. **Pi 5 bay** — board flat, Active Cooler up, USB/Ethernet through the
   fascia (flush: the ports overhang 3.0 mm against a 3 mm fascia, per the
   official drawing), SD card reachable from the rear. The board sits on two
   full-length rails rooted in the fascia, on four **M2.5** heat-set inserts
   (bore 3.5, pressed in from above), screwed with **M2.5×6** through the
   Pi's corner holes. The Active Cooler uses its own two dedicated holes, so
   the corners stay free. Those cooler holes sit 6 mm inboard of the rail
   lines at exactly the insert positions (official drawing: 6 mm from the
   GPIO-corner and USB-C-corner mounting holes), and the cooler's spring
   pins clip **through** the board and flare ~2.5 mm below it — so the rails
   sit asymmetrically about their hole lines (2.75 inboard / 4.25 outboard),
   leaving the clips in free air with 0.25 mm to spare at a 6 mm flare.
   Asserts guard both the clip clearance and the insert-bore wall.
3. **CH9121 station** — the carrier, printed in place, RJ45 centred at X +85.
   Its board inserts still press in from the tray underside, which stays open
   below. The Pi's GPIO edge faces it, so the dupont run to the header is
   short.

Cooler headroom: PCB top sits at Y −5.9, cooler reaches ~+10.1 against a
+22.25 panel edge. HDMI adapter body reaches ~3 mm below the PCB underside;
the tray floor is 7.5 mm below it.

**Printing:** fascia face down, same as the carrier — everything grows
straight back, no supports. Rotate 45° on the bed if the 254 mm width does
not fit square; the orientation relative to the bed normal is what matters.

```bash
OS=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
$OS --backend=manifold -o pi5_ch9121_1u.stl        pi5_ch9121_1u.scad
$OS --backend=manifold -o pi5_ch9121_1u_coupon.stl -D 'part="coupon"' pi5_ch9121_1u.scad
```

Hardware for the whole panel: **4 × M2.5 heat-set inserts (3.5 mm bore —
VERIFY yours) + 4 × M2.5×6 screws** for the Pi, and **2 × M2 inserts +
2 × M2×6** for the CH9121 board (pressed from the tray underside, exactly as
on the standalone carrier). The carrier's flange inserts and screws are not
used — the flange is printed into the panel.

There is also `ch9121_rj45_cutter.stl` — a plain 16.8 × 14.5 × 40 cuboid of
the test-fitted RJ45 opening, centred on the origin, for subtracting the same
opening from any other model (`part="cutter"` in `ch9121_mount.scad`).
