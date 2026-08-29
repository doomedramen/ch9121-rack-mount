// ============================================================================
// 1U 10-INCH RACK PANEL  --  ONE RASPBERRY PI 5  +  CH9121 CARRIER, ONE PIECE
//
// Adapted from "RPi 2B/3B/4B/5B 10-inch Rack Mount V1_2" (pi_references/):
// same 254 x 44.5 x 3 fascia, same rack-ear slots, same print concept -
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
// Layout, viewed from the FRONT of the rack, left to right:
//   1. open cable bay   - the Pi's USB-C power and the micro-HDMI -> HDMI
//                         adapter exit sideways (viewer's left) into ~110mm
//                         of open space
//   2. Pi 5 bay         - board flat, cooler up, USB/Ethernet through the
//                         fascia, SD card reachable from the rear
//   3. ch9121 station   - the carrier, printed in place. The Pi's GPIO edge
//                         faces it, so the dupont run is short.
//
// Axes (same convention as ch9121_mount.scad):
//   X = left / right, 0 at panel centre (+X = viewer's right)
//   Y = up / down,    0 at panel centre
//   Z = front -> back, 0 at the exterior face of the fascia
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

$fn = 48;

// ---------------------------------------------------------------------------
// 1. PANEL / RACK  (measured off the reference 10-inch rack mount STL)
// ---------------------------------------------------------------------------
panel_w   = 254.0;   // 10-inch rack panel width
panel_h   = 44.5;    // 1U
fascia_t  = 3.0;
panel_r   = 2.0;     // outer corner radius

ear_slot_cx = 119.0;  // slot centres, +/-X            (reference: 119.06)
ear_slot_cy = 15.9;   // slot centres, +/-Y
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

// M2.5 hardware for the Pi (its holes are 2.7mm - too big for M2 to locate,
// exactly right for M2.5).
pi_insert_d     = 3.5;   // M2.5 heat-set insert bore                  VERIFY
pi_insert_depth = 5.0;   // suits a 4-5mm M2.5 insert
pi_screw_len    = 6.0;   // M2.5x6, length under the head

// Official Active Cooler: 13.7mm above the PCB top face (official mechanical
// drawing; 16 kept as the clearance budget), fixed by its own two dedicated
// spring-pin holes - the four corner holes stay free.
cooler_h = 16.0;

// The cooler's two 3mm spring-pin holes, from the official Pi 5 drawing:
// each sits 6mm from a corner mounting hole ALONG ITS RAIL LINE'S INBOARD
// SIDE - one 6mm below the GPIO-corner hole (board 61.5, 46.5), one 6mm
// above the USB-C-corner hole (board 3.5, 9.5). The pins clip THROUGH the
// board and flare ~2.5mm below it. They land 6mm inboard of the rail
// centrelines at exactly the insert Z positions, which is why the rails sit
// asymmetrically about their hole lines (rail_in below): a centred 7mm rail
// would catch the clips and rock the board.
fan_lug_from_hole = 6.0;   // inboard of the corner hole, along board width
fan_lug_d         = 6.0;   // clip flare diameter under the board     VERIFY
fan_lug_below     = 2.5;   // clip protrusion below the PCB underside VERIFY

// ---------------------------------------------------------------------------
// 3. LAYOUT
// ---------------------------------------------------------------------------
// Pi bay. The board lies flat, component side up. Its power/HDMI edge is the
// -X (viewer's left) side; USB/Ethernet face front. Board left edge:
pi_left_x  = 7.0;                       // panel X of the power/HDMI edge
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
// rails together underneath; the ~7.5mm between floor and board keeps the
// floor clear of the HDMI adapter's body, which reaches ~3mm below the PCB
// underside when plugged in.
// Rails are 7mm wide but sit asymmetrically about their hole lines: 2.75mm
// inboard, 4.25mm outboard. The cooler's spring-pin clips flare to
// ~fan_lug_d, centred 6mm inboard of the hole lines - the inboard face at
// 2.75 clears a 6mm clip by 0.25, while still leaving the insert bore a
// 1.0mm wall (the carrier gets by with 0.76).
rail_in       = 2.75;                   // rail reach inboard of the hole line
rail_out      = 4.25;                   // rail reach outboard
rail_top_y    = pi_bot_y;               // Pi seats here
pi_floor_top_y = -15.0;
pi_floor_t     = 3.0;
rail_h         = rail_top_y - pi_floor_top_y;   // = 7.5

pi_front_z  = fascia_t;                 // board front edge butts the fascia
pi_rear_z   = pi_front_z + pi_l;        // = 88
rail_end_z  = pi_rear_z;                // rails run the full board length
pi_floor_end_z = pi_rear_z + 2.0;       // floor overruns slightly
pi_floor_x0 = pi_left_x - 5.0;          // floor extends a little past the
                                        // board on both sides
pi_floor_x1 = pi_left_x + pi_w + 3.0;   // (tighter on the GPIO side - the
                                        //  ch9121 flange starts at X=67)

// under-floor gussets bracing the tray back to the fascia
gusset_len = 40.0;   // along Z
gusset_h   = 4.0;    // below the floor
gusset_t   = 3.0;

// rail X centres = the Pi hole lines
rail_cx = [pi_left_x + pi_hole_from_pwr[0], pi_left_x + pi_hole_from_pwr[1]];
// hole Z positions (board front edge at Z=3, holes measured from the rear)
hole_z  = [pi_rear_z - pi_hole_from_rear[0], pi_rear_z - pi_hole_from_rear[1]];

// ---------------------------------------------------------------------------
// 5. SANITY CHECKS
// ---------------------------------------------------------------------------
assert(pi_top_y + cooler_h <= panel_h/2 - 2.0,
       "cooler does not clear the top of the 1U envelope");
assert(pi_floor_top_y - pi_floor_t >= -panel_h/2 + 1.0,
       "tray floor breaks out of the bottom of the 1U envelope");
assert(pi_insert_depth + 1.5 <= rail_h + pi_floor_t,
       "rail + floor too shallow for the insert bore plus margin");
assert(pi_screw_len - pi_t <= pi_insert_depth,
       "Pi screw bottoms out in the insert bore");
assert(pi_screw_len - pi_t >= 3.0,
       "Pi screw barely enters the insert");
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
assert(ch_cx - flange_w/2 > pi_floor_x1,
       "Pi tray floor runs under the ch9121 flange");
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
assert(rail_in - pi_insert_d/2 >= 0.7,
       "insert bore wall too thin on the rail's inboard side");
assert(fan_lug_below < rail_h,
       "cooler clips reach below the rail height into the floor");

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

module fascia() {
    difference() {
        rounded_rect_prism(panel_w, panel_h, panel_r, 0, fascia_t);

        // rack ear slots
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*ear_slot_cx, sy*ear_slot_cy, 0]) ear_slot();

        // Pi port opening
        translate([pi_open_cx, pi_open_cy, -0.5])
            rounded_rect_prism(pi_open_w, pi_open_h, pi_open_r,
                               0, fascia_t + 1);

        // RJ45 opening: the carrier's own test-fitted size, aligned with the
        // opening through the carrier flange that sits directly behind
        translate([ch_cx, ch_cy, -0.5])
            rounded_rect_prism(carrier_rj45_w, carrier_rj45_h, carrier_rj45_r,
                               0, fascia_t + 1);
    }
}

// Floor plate + the two seating rails, rooted in the fascia.
module pi_tray() {
    // floor
    translate([pi_floor_x0, pi_floor_top_y - pi_floor_t, fascia_t])
        cube([pi_floor_x1 - pi_floor_x0, pi_floor_t,
              pi_floor_end_z - fascia_t]);

    // rails, asymmetric about their hole lines (inboard = toward the board
    // centre at pi_cx) so the cooler's under-board clips clear them
    for (x = rail_cx)
        translate([x < pi_cx ? x - rail_out : x - rail_in,
                   pi_floor_top_y, fascia_t])
            cube([rail_in + rail_out, rail_h, rail_end_z - fascia_t]);

    // under-floor gussets tying the tray back to the fascia. Right-angle
    // triangles in the YZ plane - the hypotenuse prints at 45 degrees.
    // rotate([90,0,90]) maps polygon (a,b) -> (Y,Z): legs 4mm down the
    // fascia and 40mm back along the floor's underside.
    for (x = [pi_floor_x0, pi_floor_x1 - gusset_t])
        translate([x, pi_floor_top_y - pi_floor_t, fascia_t])
            rotate([90, 0, 90])
            linear_extrude(height = gusset_t)
                polygon([[0, 0], [-gusset_h, 0], [0, gusset_len]]);
}

// Insert bores, drilled down into the rail tops from above.
module pi_screw_holes() {
    for (p = pi_hole_positions())
        translate([p[0], rail_top_y + 0.01, p[1]])
            rotate([90, 0, 0])
                cylinder(d = pi_insert_d, h = pi_insert_depth + 0.01);
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

if (part == "coupon")
    intersection() {
        panel();
        translate([pi_left_x - 12, -panel_h/2 - 1, -1])
            cube([(ch_cx + flange_w/2 + 7) - (pi_left_x - 12),
                  panel_h + 2, coupon_len + 1]);   // stops at X=110, short of
                                                   // the ear slots at 112.5
    }
else
    panel();

if (show_reference && part == "panel") reference_pi5();
