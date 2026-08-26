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
pcb_l = 43.0;    // PCB length, front (RJ45) edge to rear (header) edge
pcb_w = 25.5;    // PCB width
pcb_t = 1.6;     // PCB thickness                                     VERIFY

// The RJ45 magjack hangs off the front edge of the PCB. This is the single
// most important number in the file: the front slab MUST be thinner than it,
// or the connector cannot reach the outside of the panel.
rj45_overhang = 4.2;                                              // VERIFY

rj45_body_w      = 16.0;   // magjack shell width
rj45_body_h      = 13.0;   // magjack shell height ABOVE the PCB top face  VERIFY
underside_clear  = 2.0;    // the magjack's heat-staked posts and the RJ45
                            // solder tails stick out below the PCB     VERIFY

// The module's two mounting holes, both near the front (RJ45) corners.
pcb_hole_dx   = 10.5;   // +/- from the PCB centreline                 VERIFY
pcb_hole_dz   = 2.7;    // back from the PCB front edge                VERIFY
// Holes scale to ~3.0-3.2mm on the photos: that is M2.5 clearance, and marginal
// for M3. Default here is M2.5. If yours measure >=3.3mm, switch to M3 (4.2).
pcb_insert_d      = 3.6;   // M2.5 heat-set insert bore (M3 = 4.2)     VERIFY
pcb_insert_depth  = 4.0;   // insert length + a little
pcb_boss_pad      = 1.6;   // material around the insert bore

// ---------------------------------------------------------------------------
// 2. RACK FASCIA HAND-CUT OPENING (reference only, you cut this by hand)
// ---------------------------------------------------------------------------
rack_hole_w = 18.0;
rack_hole_h = 15.5;

// ---------------------------------------------------------------------------
// 3. CARRIER RJ45 OPENING (printed, tighter than the hand-cut hole)
// ---------------------------------------------------------------------------
carrier_rj45_w = 17.0;
carrier_rj45_h = 14.5;
carrier_rj45_r = 0.8;
rj45_y_trim    = 0;     // nudge the opening up/down if the magjack does not
                         // sit where rj45_body_h says it does          VERIFY

// ---------------------------------------------------------------------------
// 4. TRAY
// ---------------------------------------------------------------------------
floor_t      = 2.5;   // tray floor thickness (also the insert boss root)
wall_t       = 2.0;   // side wall thickness
side_clear   = 0.3;   // per-side lateral clearance around the PCB
side_wall_h  = 7.0;   // wall height above the floor's top face
standoff_h   = 3.0;   // PCB underside height above the floor top face
                       // (must clear underside_clear)
// The side walls stop short of the rear so nothing crowds the dupont housings
// on the 2x8 header. The floor still runs the full length so the board is
// backed up when you push connectors on.
rear_wall_relief = 7.0;
tray_tail        = 1.0;   // floor overrun past the PCB rear edge

// ---------------------------------------------------------------------------
// 5. FLANGE (mates to the rear face of the rack fascia)
// ---------------------------------------------------------------------------
front_t  = 4.0;    // MUST be < rj45_overhang - see assert below
flange_w = 36.0;
flange_h = 28.0;

include_flange_screws = true;
flange_hole_spacing_x = 28.0;
flange_insert_d       = 4.2;   // M3 heat-set insert bore               VERIFY
flange_insert_depth   = 5.5;   // suits a standard 5.0mm-long M3 insert
flange_screw_d        = 3.4;   // relief behind the insert for screw overrun
flange_boss_w         = 8.0;   // rear-face boss, gives the insert its depth
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
assert(pcb_insert_depth + 0.8 <= standoff_h + floor_t,
       "PCB insert bore would break through the tray floor");
assert(flange_insert_depth + 0.8 <= front_t + flange_boss_h,
       "flange insert bore would break through the flange face");
assert(flange_y0 <= rj45_cy - carrier_rj45_h/2 - 1.5 &&
       flange_y0 + flange_h >= rj45_cy + carrier_rj45_h/2 + 1.5,
       "flange is too short in Y to surround the RJ45 opening");
assert(flange_y0 <= tray_bot_y,
       "flange does not reach down far enough to back up the tray floor");
assert(pcb_hole_dx + pcb_insert_d/2 + pcb_boss_pad <= cavity_w/2 + wall_t,
       "PCB insert boss would stick out past the tray side wall");

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

// Rectangular bosses under the PCB's own mounting holes. Rectangular rather
// than round on purpose: every face is either vertical or bonded to the slab,
// so the boss is fully self-supporting in the print orientation.
module pcb_bosses() {
    b = pcb_insert_d + 2*pcb_boss_pad;
    for (p = pcb_hole_positions())
        difference() {
            translate([p[0] - b/2, tray_bot_y, p[1] - b/2])
                cube([b, floor_t + standoff_h, b]);
            // insert bore, open upward at the PCB seating face
            translate([p[0], standoff_h + 0.01, p[1]])
                rotate([90, 0, 0])
                    cylinder(d = pcb_insert_d, h = pcb_insert_depth + 0.01);
        }
}

// Unbored pads at the rear corners so the board is backed up when dupont
// connectors are pushed onto the header.
module rear_support_pads() {
    b = 5.0;
    for (s = [-1, 1])
        translate([s * pcb_hole_dx - b/2, tray_bot_y, pcb_rear_z - b - 0.5])
            cube([b, floor_t + standoff_h, b]);
}

// Fins bracing the side walls back against the flange.
module gussets() {
    g = 5.0;
    for (s = [-1, 1])
        translate([s * (cavity_w/2 + wall_t/2) - wall_t/2, 0, front_t])
        rotate([90, 0, 90])
        linear_extrude(height = wall_t)
            polygon([[0, 0], [g, 0], [0, g]]);
}

module ch9121_carrier() {
    union() {
        flange();
        tray();
        pcb_bosses();
        rear_support_pads();
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
    // 2x8 header block on the rear edge
    color([0.1, 0.1, 0.1, 0.5])
        translate([-9.0, pcb_top_y, pcb_rear_z - 5.5])
            cube([18.0, 2.5, 5.0]);
}

// ============================================================================
// FINAL ASSEMBLY
// ============================================================================
ch9121_carrier();
if (show_reference) reference_module();
