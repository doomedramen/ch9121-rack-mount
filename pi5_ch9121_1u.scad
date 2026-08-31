// ============================================================================
// 1U 10-INCH RACK PANEL  --  ONE RASPBERRY PI 5  +  CH9121 CARRIER, ONE PIECE
//
// SOURCES for the numbers in section 2. Anything not traceable to one of
// these is measured off the reference OBJ and tagged VERIFY at its
// definition:
//   Pi 5 board + ports:
//     https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-mechanical-drawing.pdf
//     85 x 56 board, 2.7mm corner holes on a 58 x 49 pattern, 3.0mm port
//     overhang. (Beware: 58 is the HOLE SPACING, not the board width.)
//   Active Cooler:
//     https://datasheets.raspberrypi.com/cooling/raspberry-pi-active-cooler-mechanical-drawing.pdf
//     13.7mm tall over the PCB. It does NOT dimension the push-pin holes or
//     the under-board clip - see the fan_lug notes below.
//   Rack: 10-inch racks are a de-facto format, but reuse EIA-310's vertical
//     geometry - 1.75in U, ear slots 1.25in apart.
//
// Adapted from "RPi 2B/3B/4B/5B 10-inch Rack Mount V1_2" (pi_references/):
// same 254 x 3 fascia, same rack-ear slots, same print concept -
// fascia face down on the bed, everything grows straight back in +Z, nothing
// overhangs in -Z, no supports. Print rotated 45 degrees on the bed if the
// plate does not fit square - the orientation relative to the bed NORMAL is
// what matters, not the rotation about it.
//
// The CH9121 carrier is PART OF THIS PRINT: ch9121_mount.scad is included
// below and its ch9121_carrier() is unioned onto the back of the fascia,
// flange face flush with the panel front. Its two flange screws and bosses
// are dropped (include_flange_screws = false) - nothing to screw to when the
// flange grows out of the panel - and the fascia carries the carrier's own
// test-fitted 16.8 x 14.5 opening, not the looser hand-cut stencil hole.
// The carrier's two PCB inserts still press in from the tray underside,
// which stays open below.
//
// Layout of the EMITTED (mirrored) part, viewed from the FRONT of the
// rack, left to right:
//   1. open cable bay   - the Pi's USB-C power and the micro-HDMI -> HDMI
//                         adapter exit sideways (viewer's left) into ~110mm
//                         of open space
//   2. Pi 5 bay         - board flat, cooler up, USB/Ethernet through the
//                         fascia, SD card reachable from the rear
//   3. ch9121 station   - the carrier, printed in place. The Pi's GPIO edge
//                         faces it, so the dupont run is short.
//
// Axes (same convention as ch9121_mount.scad):
//   X = left / right, 0 at panel centre
//   Y = up / down,    0 at panel centre
//   Z = front -> back, 0 at the exterior face of the fascia
//
// HANDEDNESS - READ BEFORE TRUSTING ANY LEFT/RIGHT BELOW. For a viewer
// standing at the FRONT of the rack (looking along +Z, up +Y), viewer-right
// is -X. This file is AUTHORED in the mirror frame (+X = viewer-LEFT,
// where a physical Pi's layout constants read naturally), and the final
// assembly emits mirror([1,0,0]) of everything, producing the physical
// part. A physical Pi 5 with ports facing front and cooler up has its
// power/HDMI edge on the viewer's LEFT and GPIO on the viewer's RIGHT -
// the mirrored output honours that; the raw authored model does not.
//
// >>> Dimensions marked "VERIFY" are read off the reference STL / OBJ models,
// >>> not a datasheet. Check before a production print.
// ============================================================================

// All carrier dimensions and modules come from the carrier's own file - one
// source of truth. The three assignments after it suppress its standalone
// render and its flange screw hardware (main-file assignments override
// included ones in OpenSCAD).
include <ch9121_mount.scad>
ch9121_standalone     = false;
include_flange_screws = false;

// $fn comes from the included carrier file - one source of truth for both
// parts. Asserted below so a change there can't silently coarsen this panel.

// ---------------------------------------------------------------------------
// 1. PANEL / RACK  (measured off the reference 10-inch rack mount STL)
// ---------------------------------------------------------------------------
// 10-inch racks are a de-facto convention rather than a standards-body
// format, but they reuse EIA-310's vertical geometry: the U pitch is
// 1.75in = 44.45mm, split 0.5in / 0.625in / 0.625in, which is what puts the
// two ear slots 1.25in = 31.75mm apart (ear_slot_cy below).
rack_u    = 44.45;   // one rack unit, EIA-310
panel_w   = 254.0;   // 10-inch rack panel width
// A panel has to be UNDER the U pitch, not equal to it, or it binds against
// its neighbours. 44.0 is the usual real-world 1U panel height and leaves
// ~0.2mm top and bottom. (This was 44.5 - taller than the U it sits in.)
panel_h   = 44.0;
fascia_t  = 3.0;
panel_r   = 2.0;     // outer corner radius

ear_slot_cx = 119.0;  // slot centres, +/-X            (reference: 119.06)
ear_slot_cy = 15.875; // slot centres, +/-Y: EIA-310 puts them 1.25in apart
ear_slot_w  = 13.0;   // slot length (X)
ear_slot_h  = 6.5;    // slot width  (Y), ends fully rounded

// ---------------------------------------------------------------------------
// 2. RASPBERRY PI 5  (measured off the reference OBJ; holes cross-checked
//    against the official mechanical drawing)
// ---------------------------------------------------------------------------
pi_l = 85.0;    // board length, port edge to SD edge
pi_w = 56.0;    // board width
pi_t = 1.6;     // PCB thickness

// USB/Ethernet stack on the front edge: bodies overhang the PCB edge by
// 3.0mm (official mechanical drawing) - flush with the 3mm fascia - and rise
// 15.5mm above the PCB top face (measured, OBJ).                      VERIFY
pi_port_overhang = 3.0;
pi_port_h        = 15.5;
// The port bodies span 2.4..53.0 across the board, measured from the
// power/HDMI edge (OBJ).                                              VERIFY
pi_port_x0 = 2.4;
pi_port_x1 = 53.0;

// Mounting holes: 2.7mm, 3.5mm in from the edges, 58 x 49 pattern.
// Measured from the SD (rear) edge and the power/HDMI edge.
pi_hole_from_rear  = [3.5, 61.5];   // along the board length
pi_hole_from_pwr   = [3.5, 52.5];   // across the board width
pi_hole_d          = 2.7;           // the board's own holes, for reference

// micro-HDMI -> HDMI adapter: its body hangs below the PCB once plugged in,
// and the tray floor has to stay clear of it
hdmi_below_pcb  = 3.0;   //                                            VERIFY

// M2.5 hardware for the Pi. 2.7 is the close-fit clearance hole for M2.5 -
// too big for an M2 to locate in, exactly right for this. Note how little
// slack that is: 0.1mm a side, and all four have to line up at once, so
// print shrinkage across the 58 x 49 pattern is what will fight you on
// assembly, not the screw diameter. Start all four before tightening any.
pi_screw_d      = 2.5;   // M2.5 major diameter, for the clearance assert
pi_insert_d     = 3.5;   // M2.5 heat-set insert bore                  VERIFY
pi_insert_depth = 5.0;   // total bore depth from the rail top
pi_screw_len    = 6.0;   // M2.5x6, length under the head

// Relief counterbore at the mouth of each insert bore. The inserts press in
// from ABOVE (the floor is solid underneath, so there is no reaching them
// from below like the carrier's are), which puts the insert's own top face
// at the board's seating plane. Left flush, an insert that ends up even
// slightly proud lifts the Pi onto four rims and it rocks. Sinking the bore
// mouth by this much gives a proud insert somewhere to go.
// 4.0 is about the OD of a common M2.5 insert, which is the size that has to
// fit. If yours are fatter, this has to grow with them - and the rail cannot
// give much, so check the wall assert below rather than just widening it.
pi_insert_relief_d = 4.0;   // wider than the insert, to clear a flared knurl
pi_insert_relief_h = 0.3;   // deeper than an insert is likely to sit proud

// Official Active Cooler: 13.7mm above the PCB top face (official mechanical
// drawing; 16 kept as the clearance budget), fixed by its own two dedicated
// spring-pin holes - the four corner holes stay free.
cooler_h = 16.0;

// The cooler's two 3mm spring-pin holes, from the official Pi 5 drawing:
// each sits 6mm from a corner mounting hole ALONG ITS RAIL LINE'S INBOARD
// SIDE - one 6mm below the GPIO-corner hole (board 61.5, 46.5), one 6mm
// above the USB-C-corner hole (board 3.5, 9.5). The pins clip THROUGH the
// board and flare ~2.5mm below it. They land 6mm inboard of the rail
// centrelines at exactly the insert Z positions, which caps how far a rail
// may reach inboard (rail_half below): a 7mm rail would catch the clips and
// rock the board.
// Neither the Pi 5 drawing nor the Active Cooler drawing dimensions the
// push-pin holes or the clip that flares under the board - that is a real gap
// in the official documentation, so both numbers below are deliberately
// PESSIMISTIC rather than measured. Note which direction each errs:
//   fan_lug_d  - a BIGGER flare forces a NARROWER rail, so overstating it is
//                the safe way to be wrong. Scaling the cooler drawing suggests
//                ~3.6, i.e. the 6.0 here is generous. Do not shrink it to suit
//                a wider rail without measuring a real cooler.
//   fan_lug_below - a DEEPER clip needs more air under the board. Scaling the
//                same drawing suggests ~3.2, so that is what is used.
fan_lug_from_hole = 6.0;   // inboard of the corner hole, along board width
fan_lug_d         = 6.0;   // clip flare diameter under the board     VERIFY
fan_lug_below     = 3.2;   // clip protrusion below the PCB underside VERIFY

// ---------------------------------------------------------------------------
// 3. LAYOUT
// ---------------------------------------------------------------------------
// Pi bay. The board lies flat, component side up, USB/Ethernet facing
// front. In this AUTHORED frame the power/HDMI edge is the low-X side of
// the bay; the output mirror puts it on the physical viewer's LEFT, exiting
// into the open cable bay, with GPIO facing the carrier:
pi_left_x  = 7.0;                       // authored X of the power/HDMI edge
pi_cx      = pi_left_x + pi_w/2;        // = 35
// Vertical: the PCB sits a full board thickness LOWER than the opening
// implies - the opening's bottom edge lands 0.25 below the PCB TOP face
// (the port undersides), not below the PCB. The board nose hides behind
// the fascia and butts it as a full-width hard stop; only the top 0.25 of
// the PCB edge shows in the opening.
pi_bot_y   = -9.1;                      // PCB underside
pi_top_y   = pi_bot_y + pi_t;           // = -7.5, port undersides

// Fascia opening for the port stack. Height keeps the reference panel's
// PCB+ports stack (17.1) plus clearance even though the PCB no longer
// passes through it - the spare ~1.85 sits ABOVE the ports and absorbs any
// error in pi_port_h, which is measured off the OBJ, not the datasheet.
pi_open_clear = 0.25;
pi_open_w  = (pi_port_x1 - pi_port_x0) + 2.7 + 2*pi_open_clear;  // ref 53.3+
pi_open_h  = pi_t + pi_port_h + 2*pi_open_clear;                 // ref 17.1+
pi_open_cx = pi_left_x + (pi_port_x0 + pi_port_x1)/2;            // = 34.7
pi_open_cy = pi_top_y - pi_open_clear + pi_open_h/2;             // ~ 1.05
pi_open_r  = 0.8;

// ch9121 station: where the carrier's RJ45 opening centre lands on the
// panel. The carrier is translated so its (0, rj45_cy, 0) maps here; its
// flange face at Z=0 stays flush with the panel front.
ch_cx = 85.0;
ch_cy = pi_open_cy;    // visually level with the Pi opening

// ---------------------------------------------------------------------------
// 4. PI TRAY STRUCTURE (all rooted in the fascia at Z=3, grows in +Z)
// ---------------------------------------------------------------------------
// Two rails run under the Pi's two mounting-hole lines, full board length.
// The board seats on the rail tops; four M2.5 inserts press in from above
// (open-top part - the iron comes straight down). A floor plate ties the
// rails together underneath; the 5.9mm between floor and board keeps the
// floor clear of the HDMI adapter's body, which reaches ~3mm below the PCB
// underside when plugged in, leaving ~2.9mm to spare (asserted below).
// Rails are CENTRED on their hole lines - an off-centre bore leaves unequal
// wall around the insert and the iron drifts toward the thin side going in.
// Width is set by the inboard limit: the cooler's spring-pin clips flare to
// ~fan_lug_d, centred 6mm inboard of the hole lines, so a face at 2.75
// clears a 6mm clip by 0.25. Mirrored outboard that makes a 5.5mm rail with
// a 1.0mm wall all round the bore (the carrier gets by with 0.76).
rail_half     = 2.75;                   // rail reach each side of the hole line
rail_in       = rail_half;              // inboard reach (clip clearance)
rail_out      = rail_half;              // outboard reach
rail_top_y    = pi_bot_y;               // Pi seats here
pi_floor_top_y = -15.0;
pi_floor_t     = 3.0;
rail_h         = rail_top_y - pi_floor_top_y;   // = 5.9

pi_front_z  = fascia_t;                 // board front edge butts the fascia
pi_rear_z   = pi_front_z + pi_l;        // = 88
rail_end_z  = pi_rear_z;                // rails run the full board length
pi_floor_end_z = pi_rear_z + 2.0;       // floor overruns slightly
pi_floor_x0 = pi_left_x - 5.0;          // floor extends a little past the
                                        // board on both sides
pi_floor_x1 = pi_left_x + pi_w + 2.0;   // (tighter on the GPIO side - the
                                        //  ch9121 flange starts at X=67)

// Two printed faces can each come out ~0.2-0.4 proud, so any nominal gap
// between separately-grown solids needs to survive ~0.8 of closing before
// they touch. Used by the tray-floor / carrier-flange assert below.
print_gap_min = 1.5;

// Under-floor stiffening ribs, rooted in the fascia and tapering out along
// the tray's underside. They deepen the floor's section over the cantilever
// root, where the Pi's weight puts the most bending into it. NOT 45-degree
// knee braces - the profile is a long shallow taper (gusset_h over
// gusset_len, ~5.7 degrees off vertical), which is what lets it print with
// no support: every layer going up in +Z is smaller than the one below it,
// so the rib recedes rather than overhangs.
// Depth is capped by the 1U envelope, not by strength - see the assert.
gusset_len = 40.0;   // along Z
gusset_h   = 3.0;    // below the floor
gusset_t   = 3.0;

// Fillet in the inside corner where the floor top meets the back of the
// fascia - the cantilever root, and the sharp corner a bending crack would
// start from. Must stay well clear of the board seating plane above it.
root_fillet = 2.5;

// rail X centres = the Pi hole lines
rail_cx = [pi_left_x + pi_hole_from_pwr[0], pi_left_x + pi_hole_from_pwr[1]];
// hole Z positions (board front edge at Z=3, holes measured from the rear)
hole_z  = [pi_rear_z - pi_hole_from_rear[0], pi_rear_z - pi_hole_from_rear[1]];

// ---------------------------------------------------------------------------
// 5. SANITY CHECKS
// ---------------------------------------------------------------------------
assert($fn >= 32,
       "$fn too coarse for the bores - check the include still sets it");
assert(panel_h < rack_u,
       "panel is taller than one rack unit - it will bind on its neighbours");
assert(ear_slot_cy*2 + ear_slot_h < panel_h,
       "ear slots run off the top or bottom edge of the panel");
assert(pi_top_y + cooler_h <= panel_h/2 - 2.0,
       "cooler does not clear the top of the 1U envelope");
assert(pi_floor_top_y - pi_floor_t >= -panel_h/2 + 1.0,
       "tray floor breaks out of the bottom of the 1U envelope");
// the gussets hang below the floor, so they - not the floor - set the tray's
// real low-water mark
assert(pi_floor_top_y - pi_floor_t - gusset_h >= -panel_h/2 + 1.0,
       "under-floor gussets break out of the bottom of the 1U envelope");
assert(pi_insert_depth + 1.5 <= rail_h + pi_floor_t,
       "rail + floor too shallow for the insert bore plus margin");
// The screw drops pi_screw_len - pi_t below the board's top face, but the
// first pi_insert_relief_h of that is air in the relief counterbore, so the
// thread only engages the insert for what is left. The insert itself has the
// bore minus the relief to sit in.
assert(pi_screw_len - pi_t - pi_insert_relief_h
         <= pi_insert_depth - pi_insert_relief_h,
       "Pi screw bottoms out in the insert bore");
assert(pi_screw_len - pi_t - pi_insert_relief_h >= 3.0,
       "Pi screw barely enters the insert");
// the board's own holes have to pass the screw in the first place
assert(pi_screw_d < pi_hole_d,
       "Pi screw will not pass through the board's mounting holes");
assert(pi_open_cx - pi_open_w/2 > pi_left_x - 2.0 &&
       pi_open_cx + pi_open_w/2 < pi_left_x + pi_w + 2.0,
       "Pi port opening strays past the board envelope");
assert(pi_top_y + pi_port_h + 0.25 <= pi_open_cy + pi_open_h/2,
       "port stack does not clear the top of the fascia opening");
assert(pi_top_y - pi_open_clear >= pi_bot_y,
       "fascia opening dips below the PCB underside - the front stop is gone");
assert(ch_cx - flange_w/2 > pi_left_x + pi_w + 2.0,
       "ch9121 flange overlaps the Pi bay - GPIO edge needs clearance");
assert(ch_cx + flange_w/2 < panel_w/2 - 8.0,
       "ch9121 flange runs into the rack ear zone");
assert(ch_cy + flange_h/2 < panel_h/2 - 1.0 &&
       ch_cy - flange_h/2 > -panel_h/2 + 1.0,
       "ch9121 flange does not fit the panel height");
assert(ch_cy - rj45_cy + tray_bot_y > -panel_h/2 + 1.0,
       "ch9121 tray floor breaks out of the bottom of the 1U envelope");
// a dupont housing stands ~14mm above the board it plugs into
assert(ch_cy - rj45_cy + pcb_top_y + 14.0 < panel_h/2,
       "dupont housings on the ch9121 header crowd the top of the 1U envelope");
assert(ch_cx - flange_w/2 - pi_floor_x1 >= print_gap_min,
       "Pi tray floor crowds the ch9121 flange - gap is inside print tolerance");
assert(ear_slot_cx + ear_slot_w/2 < panel_w/2 - 1.0,
       "ear slots break out of the panel");
assert(rail_cx[0] - rail_out >= pi_floor_x0 &&
       rail_cx[1] + rail_out <= pi_floor_x1,
       "rails stray past the tray floor");
assert(pi_floor_end_z >= rail_end_z,
       "rails outrun the floor that carries them");
// cooler spring-pin clips: flare must clear the rail inboard faces, and the
// insert bore must keep a wall on the inboard side
assert(rail_in <= fan_lug_from_hole - fan_lug_d/2,
       "rail inboard face catches the cooler's under-board clips");
// Every insert bore must sit centred in the rail the tray actually emits,
// with wall to spare on both sides. Checked against rail_x0()/rail_x1() -
// the same functions pi_tray() builds the rails from - so this catches a
// rail that drifts off its hole line, not just a typo in one constant.
for (p = pi_hole_positions()) {
    assert(abs((p[0] - rail_x0(p[0])) - (rail_x1(p[0]) - p[0])) < 1e-9,
           "insert bore sits off-centre in its rail");
    assert(p[0] - rail_x0(p[0]) - pi_insert_d/2 >= 0.7 &&
           rail_x1(p[0]) - p[0] - pi_insert_d/2 >= 0.7,
           "insert bore wall too thin - rail is narrower than the bore needs");
    // the relief is wider than the bore, so IT sets the thinnest wall
    assert(p[0] - rail_x0(p[0]) - pi_insert_relief_d/2 >= 0.7 &&
           rail_x1(p[0]) - p[0] - pi_insert_relief_d/2 >= 0.7,
           "insert relief counterbore leaves too thin a wall at the rail top");
}
assert(pi_insert_relief_d > pi_insert_d,
       "insert relief must be wider than the bore it opens up");
assert(pi_insert_relief_h < pi_insert_depth,
       "insert relief would swallow the whole insert bore");
// the HDMI adapter body hangs below the PCB; the floor must stay under it
assert(rail_h >= hdmi_below_pcb + 1.5,
       "tray floor fouls the HDMI adapter body hanging under the PCB");
assert(fan_lug_below < rail_h,
       "cooler clips reach below the rail height into the floor");
assert(root_fillet < rail_h - 1.0,
       "root fillet reaches up into the board's seating plane");
assert(root_fillet < pi_l/4,
       "root fillet runs too far back under the board");

// ============================================================================
// MODULES  (rounded_rect_prism comes from the included carrier file)
// ============================================================================

// Slot with fully-rounded ends, long axis X, cut through the fascia.
module ear_slot() {
    hull()
        for (s = [-1, 1])
            translate([s*(ear_slot_w - ear_slot_h)/2, 0, -0.5])
                cylinder(d = ear_slot_h, h = fascia_t + 1);
}

function pi_hole_positions() =    // [x, z] pairs, all four
    [for (x = rail_cx, z = hole_z) [x, z]];

// The X extent of the rail carrying the hole line at cx. Single source of
// truth: pi_tray() builds from these and the sanity checks verify them.
function rail_x0(cx) = cx - rail_out;
function rail_x1(cx) = cx + rail_in;

module fascia() {
    difference() {
        rounded_rect_prism(panel_w, panel_h, panel_r, 0, fascia_t);

        // rack ear slots
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*ear_slot_cx, sy*ear_slot_cy, 0]) ear_slot();

        // Pi port opening
        translate([pi_open_cx, pi_open_cy, 0])
            bed_relieved_opening(pi_open_w, pi_open_h, pi_open_r, fascia_t);

        // RJ45 opening: the carrier's own test-fitted size, aligned with the
        // opening through the carrier flange that sits directly behind
        translate([ch_cx, ch_cy, 0])
            bed_relieved_opening(carrier_rj45_w, carrier_rj45_h,
                                 carrier_rj45_r, fascia_t);
    }
}

// Floor plate + the two seating rails, rooted in the fascia.
module pi_tray() {
    // floor
    translate([pi_floor_x0, pi_floor_top_y - pi_floor_t, fascia_t])
        cube([pi_floor_x1 - pi_floor_x0, pi_floor_t,
              pi_floor_end_z - fascia_t]);

    // rails, centred on their hole lines so each insert bore sits in the
    // middle of the rail; width is capped by the cooler's under-board clips
    for (x = rail_cx)
        translate([rail_x0(x), pi_floor_top_y, fascia_t])
            cube([rail_x1(x) - rail_x0(x), rail_h, rail_end_z - fascia_t]);

    // under-floor stiffening ribs tying the tray back to the fascia.
    // Right-angle triangles in the YZ plane: rotate([90,0,90]) maps polygon
    // (a,b) -> (Y,Z), giving legs gusset_h down the fascia and gusset_len
    // back along the floor's underside. The hypotenuse is a shallow taper,
    // not a 45-degree chamfer - see the gusset notes in section 4.
    for (x = [pi_floor_x0, pi_floor_x1 - gusset_t])
        translate([x, pi_floor_top_y - pi_floor_t, fascia_t])
            rotate([90, 0, 90])
            linear_extrude(height = gusset_t)
                polygon([[0, 0], [-gusset_h, 0], [0, gusset_len]]);

    // Fillet along the inside corner where the floor's top face meets the
    // back of the fascia. That corner is the cantilever's root and a sharp
    // internal corner is where a bending crack would start. Runs the full
    // floor width, well below the board, and grows in +Z like everything
    // else so it costs nothing to print.
    translate([pi_floor_x0, pi_floor_top_y, fascia_t])
        rotate([90, 0, 90])
        linear_extrude(height = pi_floor_x1 - pi_floor_x0)
            polygon([[0, 0], [root_fillet, 0], [0, root_fillet]]);
}

// Insert bores, drilled down into the rail tops from above.
module pi_screw_holes() {
    for (p = pi_hole_positions()) {
        translate([p[0], rail_top_y + 0.01, p[1]])
            rotate([90, 0, 0])
                cylinder(d = pi_insert_d, h = pi_insert_depth + 0.01);
        // relief at the mouth, so a proud insert cannot lift the board
        translate([p[0], rail_top_y + 0.01, p[1]])
            rotate([90, 0, 0])
                cylinder(d = pi_insert_relief_d, h = pi_insert_relief_h + 0.01);
    }
}

// The carrier, moved so its RJ45 opening centre lands at (ch_cx, ch_cy) and
// its flange face stays flush with the panel front at Z=0.
module ch9121_station() {
    translate([ch_cx, ch_cy - rj45_cy, 0]) ch9121_carrier();
}

module panel() {
    union() {
        difference() {
            union() {
                fascia();
                pi_tray();
            }
            pi_screw_holes();
        }
        // unioned after the panel's own cuts - the carrier arrives with its
        // opening and insert bores already cut inside ch9121_carrier()
        ch9121_station();
    }
}

// ============================================================================
// OPTIONAL: translucent reference geometry, visual fit-check only.
// Leave false when exporting the STL.
// ============================================================================
show_reference = false;

module reference_pi5() {
    // PCB
    color([0.1, 0.5, 0.2, 0.45])
        translate([pi_left_x, pi_bot_y, pi_front_z])
            cube([pi_w, pi_t, pi_l]);
    // USB / Ethernet stack, poking through the fascia
    color([0.7, 0.7, 0.7, 0.4])
        translate([pi_left_x + pi_port_x0, pi_top_y,
                   pi_front_z - pi_port_overhang])
            cube([pi_port_x1 - pi_port_x0, pi_port_h, 20]);
    // Active Cooler envelope
    color([0.4, 0.4, 0.45, 0.35])
        translate([pi_left_x + 8, pi_top_y, pi_front_z + 10])
            cube([pi_w - 16, cooler_h, pi_l - 25]);
    // USB-C + 2x micro-HDMI on the -X edge (positions from the OBJ, measured
    // from the SD end: 6.8..15.7, 22.8..28.9, 36.1..42.2)
    color([0.8, 0.6, 0.2, 0.5])
        for (zr = [[6.8, 15.7], [22.8, 28.9], [36.1, 42.2]])
            translate([pi_left_x - 1.5, pi_top_y,
                       pi_rear_z - zr[1]])
                cube([1.5, 3.3, zr[1] - zr[0]]);
    // HDMI adapter + mated plug clearance envelope off the rear-most HDMI
    color([0.9, 0.2, 0.2, 0.25])
        translate([pi_left_x - 75, pi_top_y - 4.5,
                   pi_rear_z - 45])
            cube([75, 12, 42]);
    // Active Cooler spring-pin clips flaring below the board - must hang in
    // free air inboard of the rails
    color([0.9, 0.1, 0.1, 0.6])
        for (p = [[pi_hole_from_pwr[1] - fan_lug_from_hole,
                   pi_hole_from_rear[1]],
                  [pi_hole_from_pwr[0] + fan_lug_from_hole,
                   pi_hole_from_rear[0]]])
            translate([pi_left_x + p[0], pi_bot_y - fan_lug_below,
                       pi_rear_z - p[1]])
                rotate([-90, 0, 0])
                    cylinder(d = fan_lug_d, h = fan_lug_below);
    // the carrier's own board / magjack / header ghosts, moved with it
    translate([ch_cx, ch_cy - rj45_cy, 0]) reference_module();
}

// ============================================================================
// WHAT TO EXPORT
//   "panel"  - the real part
//   "coupon" - the front 14mm only: both fascia openings and the first stubs
//              of the rails and carrier. Answers the fit questions (does the
//              Pi's port stack drop into its opening, does the CH9121 board
//              line up with its inserts and opening) for minutes of filament.
// ============================================================================
part       = "panel";
coupon_len = 14.0;

assert(part == "panel" || part == "coupon",
       "part must be \"panel\" or \"coupon\"");

// The mirror maps the authored frame onto the physical part - see the
// HANDEDNESS note in the header. Everything the panel unions is width-
// symmetric (Pi hole pattern, cooler lugs, the carrier itself), so only the
// LAYOUT flips: cables end up exiting the physical viewer's left.
if (part == "coupon")
    mirror([1, 0, 0]) intersection() {
        panel();
        translate([pi_left_x - 12, -panel_h/2 - 1, -1])
            cube([(ch_cx + flange_w/2 + 7) - (pi_left_x - 12),
                  panel_h + 2, coupon_len + 1]);   // stops at X=110, short of
                                                   // the ear slots at 112.5
    }
else
    mirror([1, 0, 0]) panel();

if (show_reference && part == "panel") mirror([1, 0, 0]) reference_pi5();
