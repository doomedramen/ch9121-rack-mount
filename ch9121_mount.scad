// ============================================================================
// CH9121 UART-to-Ethernet Rack Panel Carrier  --  OPEN TRAY REVISION
//
// Rear-mounted carrier for a Raspberry Pi rack fascia panel.
//
// Design intent (revised):
//   * OPEN TOP. The 2x8 pin header on the rear edge of the module is wired to
//     the Pi's GPIO with dupont jumpers, so there is no lid, no rails and no
//     snap tab - the board drops straight in from above.
//   * SCREWED, NOT GLUED. Brass heat-set inserts in two places:
//       - flange inserts  : carrier -> rack fascia (screws enter from the
//                           front of the panel)
//       - PCB bosses      : CH9121 board -> carrier floor (screws enter from
//                           above, through the board's own two holes)
//
// PRINT ORIENTATION: flange face flat on the bed at Z=0, carrier grows up in
// +Z. Nothing in the model overhangs in -Z, so no supports are needed.
//   X = left / right
//   Y = up / down        (Y=0 is the top surface of the tray floor)
//   Z = front -> back    (Z=0 is the exterior face of the flange)
//
// >>> Dimensions marked "VERIFY" are read off seller photos / a seller
// >>> dimension drawing, not a datasheet. Check with calipers before a
// >>> production print.
// ============================================================================

$fn = 48;

// ---------------------------------------------------------------------------
// 1. THE MODULE  (measured off the seller dimension drawing: 43.00 x 25.50mm)
// ---------------------------------------------------------------------------
pcb_l = 43.18;   // PCB length, front (RJ45) edge to rear (header) edge
                  // measured, 1.7 inch (excludes the magjack overhang)
pcb_w = 25.4;    // PCB width - measured, exactly 1 inch
pcb_t = 1.0;     // PCB thickness - measured

// The RJ45 magjack hangs off the front edge of the PCB. This is the single
// most important number in the file: the front slab MUST be thinner than it,
// or the connector cannot reach the outside of the panel.
rj45_overhang = 5.08;   // measured, 0.2 inch

rj45_body_w      = 16.0;   // magjack shell width
rj45_body_h      = 12.7;   // magjack shell height above the PCB top face
                            // measured, 0.5 inch
underside_clear  = 3.0;    // measured - the header's solder tails are the
                            // long thing under there, not the magjack

// The module's two mounting holes, both near the front (RJ45) corners.
// Hole centres measured 0.1 inch in from the side edges.
pcb_hole_dx   = pcb_w/2 - 2.54;   // = 10.16
pcb_hole_dz   = 2.54;   // back from the PCB front edge - assumed the same
                         // 0.1 inch inset as the sides                 VERIFY
// Holes measure 2.54mm (0.1 inch) across. That is below M2.5 clearance
// (2.7-2.9), so the board takes M2 screws. M2 is also the safe way to be
// wrong here: an M2 screw still passes a 3mm hole, whereas an M2.5 screw
// will not pass a 2.54mm one.
pcb_hole_d        = 2.54;  // measured, for reference
pcb_insert_d      = 3.2;   // M2 heat-set insert bore                  VERIFY
pcb_insert_depth  = 4.0;   // insert length + a little

// Inner edge of the two support ribs. The board rests on these, so they must
// stay clear of everything hanging off the UNDERSIDE of the magjack - its two
// heat-staked pegs (roughly +/-6.5 on the photos) and the RJ45 solder tails.
// With the holes only 2.54mm in from the board edge the bore already reaches
// x 8.56, so the ribs have to start inboard of the magjack shell (16mm wide,
// so +/-8). That is fine: what actually hangs below the board at the front is
// the magjack's heat-staked pegs, which sit around +/-6.5.           VERIFY
rib_inner_x = 7.8;

// The 2x8 header is a different problem. 8 positions at 0.1 inch pitch spans
// 17.8mm, so its outermost pins land at x +/-8.89 - right on top of the ribs.
// The ribs are therefore dropped away under the header, at the rear only, so
// the insert bosses at the front keep their full collar.
header_half_span   = 8.89;
header_pin_h       = 7.62;  // 0.3 inch above the board (reference geometry)
header_relief_x    = 9.6;   // ribs dropped inboard of this...
header_relief_len  = 8.0;   // ...over this much of the rear of the tray
header_relief_drop = 3.2;   // by this much - the 3mm tails reach almost to
                             // the floor, so the ribs are cut nearly away here

// ---------------------------------------------------------------------------
// 2. RACK FASCIA HAND-CUT OPENING (reference only, you cut this by hand)
// ---------------------------------------------------------------------------
rack_hole_w = 18.0;
rack_hole_h = 15.5;

// ---------------------------------------------------------------------------
// 3. CARRIER RJ45 OPENING (printed, tighter than the hand-cut hole)
// ---------------------------------------------------------------------------
// Deliberately loose - 1.25mm clearance on width, 1.9mm on height around the
// magjack. This opening is BEHIND the fascia, so nobody sees the gap, and the
// slack means a couple of millimetres of error in rj45_body_h / standoff_h /
// pcb_t still leaves the connector lined up with the hole.
carrier_rj45_w = 18.5;
carrier_rj45_h = 16.5;
carrier_rj45_r = 0.8;
rj45_y_trim    = 0;     // nudge the opening up/down if the magjack does not
                         // sit where rj45_body_h says it does          VERIFY

// ---------------------------------------------------------------------------
// 4. TRAY
// ---------------------------------------------------------------------------
floor_t      = 2.5;   // tray floor thickness (also the insert boss root)
wall_t       = 2.0;   // side wall thickness
side_clear   = 0.3;   // per-side lateral clearance around the PCB
side_wall_h  = 6.0;   // wall height above the floor's top face
                       // (kept low: it only has to locate the board sideways,
                       //  the screws do the holding, and a tall wall crowds
                       //  the dupont housings)
standoff_h   = 3.6;   // PCB underside height above the floor top face
                       // (must clear underside_clear)
// The side walls stop short of the rear so nothing crowds the dupont housings
// on the 2x8 header. The floor still runs the full length so the board is
// backed up when you push connectors on.
rear_wall_relief = 7.0;
tray_tail        = 1.0;   // floor overrun past the PCB rear edge

// ---------------------------------------------------------------------------
// 5. FLANGE (mates to the rear face of the rack fascia)
//    M2 throughout, same as the board screws - one insert size, one driver.
// ---------------------------------------------------------------------------
front_t  = 4.0;    // MUST be < rj45_overhang - see assert below
flange_w = 36.0;
flange_h = 28.0;

include_flange_screws = true;
flange_hole_spacing_x = 28.0;
flange_insert_d       = 3.2;   // M2 heat-set insert bore                VERIFY
flange_insert_depth   = 4.0;   // suits a 4.0mm-long M2 insert
flange_screw_d        = 2.4;   // M2 clearance - relief behind the insert for
                                // screw overrun
flange_boss_w         = 6.5;   // rear-face boss, gives the insert its depth
flange_boss_h         = 2.5;   // without thickening the whole flange

// ---------------------------------------------------------------------------
// 6. DERIVED
// ---------------------------------------------------------------------------
cavity_w    = pcb_w + 2*side_clear;
tray_out_w  = cavity_w + 2*wall_t;

pcb_bot_y   = standoff_h;                  // PCB underside
pcb_top_y   = standoff_h + pcb_t;          // PCB top face
rj45_cy     = pcb_top_y + rj45_body_h/2 + rj45_y_trim;

pcb_front_z = rj45_overhang;               // so the magjack face lands at Z=0
pcb_rear_z  = pcb_front_z + pcb_l;
floor_end_z = pcb_rear_z + tray_tail;
wall_end_z  = floor_end_z - rear_wall_relief;

flange_y0   = rj45_cy - flange_h/2;
tray_top_y  = side_wall_h;
tray_bot_y  = -floor_t;

// --- sanity checks (these fail the render loudly rather than printing junk) --
assert(front_t < rj45_overhang,
       "front_t must be less than rj45_overhang or the RJ45 cannot reach the panel");
assert(standoff_h >= underside_clear + 0.5,
       "standoff_h too low: the RJ45's underside posts will hold the PCB up");
assert(pcb_insert_d > pcb_hole_d,
       "insert bore must be wider than the board's own hole");
assert(pcb_insert_depth + 0.8 <= standoff_h + floor_t,
       "PCB insert bore would break through the tray floor");
assert(flange_insert_depth + 0.8 <= front_t + flange_boss_h,
       "flange insert bore would break through the flange face");
assert(flange_y0 <= rj45_cy - carrier_rj45_h/2 - 1.5 &&
       flange_y0 + flange_h >= rj45_cy + carrier_rj45_h/2 + 1.5,
       "flange is too short in Y to surround the RJ45 opening");
assert(rj45_cy - flange_boss_w/2 >= side_wall_h + 0.5,
       "flange insert boss nearly touches the tray side wall - leaves a sliver gap");
assert(flange_y0 <= tray_bot_y,
       "flange does not reach down far enough to back up the tray floor");
assert(cavity_w/2 + wall_t + 2.0 <= flange_w/2,
       "gusset fins would stick out past the flange edge");
assert(pcb_hole_dx - pcb_insert_d/2 - rib_inner_x >= 0.5,
       "not enough rib material inboard of the PCB insert bore");
assert(header_relief_x > rib_inner_x && header_relief_drop < standoff_h,
       "header relief groove is malformed");
assert(header_relief_x >= header_half_span + 0.4,
       "header relief is too narrow - the outer header pins would land on a rib");
assert(pcb_w/2 - header_relief_x >= 3.0,
       "rear seating band is too narrow to back the board up when you push connectors on");
assert(pcb_front_z + pcb_hole_dz + pcb_insert_d < pcb_rear_z - header_relief_len,
       "header relief would cut into the insert boss collars");
assert(pcb_hole_dx + pcb_insert_d/2 + 1.2 <= cavity_w/2 + wall_t,
       "PCB insert bore is too close to the outside of the tray wall");
assert(rib_inner_x >= rj45_body_w/2 - 1.5,
       "support ribs would run well underneath the magjack");

// ============================================================================
// MODULES
// ============================================================================

// Rounded rectangle prism, XY plane, extruded Z from z0 to z1.
module rounded_rect_prism(w, h, r, z0, z1) {
    translate([0, 0, z0])
    linear_extrude(height = z1 - z0)
    offset(r = r) offset(delta = -r)
    square([w, h], center = true);
}

function flange_hole_positions() =
    [[-flange_hole_spacing_x/2, rj45_cy], [flange_hole_spacing_x/2, rj45_cy]];

function pcb_hole_positions() =
    [[-pcb_hole_dx, pcb_front_z + pcb_hole_dz],
     [ pcb_hole_dx, pcb_front_z + pcb_hole_dz]];

// Flange + front stop slab, plus the rear-face bosses that give the flange
// inserts their full depth. Bosses sit above the tray in Y so they never
// interfere with the board.
module flange() {
    difference() {
        union() {
            translate([-flange_w/2, flange_y0, 0])
                cube([flange_w, flange_h, front_t]);

            if (include_flange_screws)
                for (p = flange_hole_positions())
                    translate([p[0] - flange_boss_w/2,
                               p[1] - flange_boss_w/2,
                               front_t])
                        cube([flange_boss_w, flange_boss_w, flange_boss_h]);
        }

        // RJ45 clearance, straight through
        translate([0, rj45_cy, -0.5])
            rounded_rect_prism(carrier_rj45_w, carrier_rj45_h, carrier_rj45_r,
                               0, front_t + flange_boss_h + 1);

        // heat-set insert bore, open at the FRONT face (the insert goes in from
        // the panel side, the screw threads into it from the panel side too),
        // with a narrower relief behind it for screw overrun.
        if (include_flange_screws)
            for (p = flange_hole_positions())
                translate([p[0], p[1], -0.01]) {
                    cylinder(d = flange_insert_d, h = flange_insert_depth);
                    cylinder(d = flange_screw_d,
                             h = front_t + flange_boss_h + 1);
                }
    }
}

// Open-top U-channel: floor + two side walls, no lid, no rails, no snap tab.
module tray() {
    // floor
    translate([-tray_out_w/2, tray_bot_y, front_t])
        cube([tray_out_w, floor_t, floor_end_z - front_t]);

    // side walls (stop short of the rear so the header stays clear)
    for (s = [-1, 1])
        translate([s * (cavity_w/2 + wall_t/2) - wall_t/2, 0, front_t])
            cube([wall_t, side_wall_h, wall_end_z - front_t]);
}

// Two continuous ribs running the whole length of the tray at the PCB's
// mounting-hole X positions. The board sits on them, and they carry the two
// heat-set inserts. Continuous (rather than isolated pads) on purpose: the
// ribs are rooted in the front slab at Z=front_t and grow straight back, so
// every face is vertical or bonded - fully self-supporting in this print
// orientation, no islands starting in mid-air.
module pcb_rails() {
    rib_outer_x = cavity_w/2 + wall_t;   // merges into the side wall
    difference() {
        for (sgn = [-1, 1])
            translate([sgn > 0 ? rib_inner_x : -rib_outer_x,
                       tray_bot_y, front_t])
                cube([rib_outer_x - rib_inner_x,
                      floor_t + standoff_h,
                      pcb_rear_z - front_t]);

        // rear relief, so the header's outer pins and their solder tails
        // never land on a rib
        for (sgn = [-1, 1])
            translate([sgn > 0 ? rib_inner_x : -header_relief_x,
                       standoff_h - header_relief_drop,
                       pcb_rear_z - header_relief_len])
                cube([header_relief_x - rib_inner_x,
                      header_relief_drop + 1,
                      header_relief_len + 1]);

        // insert bores, open upward at the PCB seating face
        for (p = pcb_hole_positions())
            translate([p[0], standoff_h + 0.01, p[1]])
                rotate([90, 0, 0])
                    cylinder(d = pcb_insert_d, h = pcb_insert_depth + 0.01);
    }
}

// Fins bracing the side walls back against the flange, on the OUTER wall face
// so they actually add section rather than sitting inside the wall.
module gussets() {
    g = 5.0;
    t = 2.0;
    for (s = [-1, 1])
        translate([s > 0 ? cavity_w/2 + wall_t : -(cavity_w/2 + wall_t + t),
                   0, front_t])
        rotate([90, 0, 90])
        linear_extrude(height = t)
            polygon([[0, 0], [g, 0], [0, g]]);
}

module ch9121_carrier() {
    union() {
        flange();
        tray();
        pcb_rails();
        gussets();
    }
}

// ============================================================================
// OPTIONAL: translucent reference geometry, visual fit-check only.
// Leave false when exporting the STL.
// ============================================================================
show_reference = false;

module reference_module() {
    // PCB
    color([0.1, 0.3, 0.7, 0.45])
        translate([-pcb_w/2, pcb_bot_y, pcb_front_z])
            cube([pcb_w, pcb_t, pcb_l]);
    // magjack
    color([0.7, 0.7, 0.7, 0.4])
        translate([-rj45_body_w/2, pcb_top_y, pcb_front_z - rj45_overhang])
            cube([rj45_body_w, rj45_body_h, 21.4]);
    // 2x8 header: black block on the board, pins standing 0.3 inch proud
    color([0.1, 0.1, 0.1, 0.5])
        translate([-header_half_span - 0.4, pcb_top_y, pcb_rear_z - 5.5])
            cube([2*header_half_span + 0.8, 2.5, 5.0]);
    color([0.8, 0.7, 0.3, 0.5])
        translate([-header_half_span - 0.4, pcb_top_y, pcb_rear_z - 5.5])
            cube([2*header_half_span + 0.8, header_pin_h, 5.0]);
}

// ============================================================================
// TEST COUPON
// Set true to export just the front slice of the part. Prints in a couple of
// minutes and answers the only two questions a caliper slip can really ruin:
// do the board's screw holes line up with the two inserts, and does the
// magjack line up with the opening. Dry-fit the board against it before
// committing to the full part or pressing any inserts in.
// ============================================================================
test_coupon = false;
coupon_len  = 14.0;

// ============================================================================
// FINAL ASSEMBLY
// ============================================================================
if (test_coupon)
    intersection() {
        ch9121_carrier();
        translate([-flange_w, flange_y0 - 1, -1])
            cube([2*flange_w, flange_h + 2, coupon_len + 1]);
    }
else
    ch9121_carrier();

if (show_reference) reference_module();
