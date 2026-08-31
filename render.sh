#!/usr/bin/env bash
# Regenerate every STL and every PNG in renders/ from the two .scad sources.
# Run from the repository root:  ./render.sh
set -euo pipefail

OS=${OPENSCAD:-openscad}
command -v "$OS" >/dev/null || {
    echo "openscad not found - set OPENSCAD=/path/to/openscad" >&2; exit 1; }

mkdir -p renders

stl() {  # stl <out> <src> [extra -D args...]
    echo "  $1"
    "$OS" --backend=manifold -o "$1" "${@:3}" "$2" 2>&1 |
        grep -E "ERROR|WARNING|Genus" || true
}

png() {  # png <out> <src> <w> <h> <scheme> <camera> [extra args...]
    echo "  $1"
    "$OS" -o "renders/$1" --imgsize="$3,$4" --colorscheme="$5" \
          --viewall --autocenter --camera="$6" "${@:7}" "$2" >/dev/null 2>&1
}

# --- cameras -----------------------------------------------------------------
# OpenSCAD gimbal rotations, as tx,ty,tz,rx,ry,rz,dist. Translation and
# distance are left at 0 because every view below uses --viewall --autocenter.
CARRIER_ISO="0,0,0,235,0,25,0"   # down onto the flange, into the open tray
CARRIER_UNDER="0,0,0,125,0,25,0" # from below - the two board insert bores
FRONT="0,0,0,180,0,0,0"          # straight-on front elevation
PANEL_ISO="0,0,0,55,0,25,0"      # down onto the tray side of the panel

echo "STLs:"
stl ch9121_carrier.stl        ch9121_mount.scad
stl ch9121_coupon.stl         ch9121_mount.scad -D 'part="coupon"'
stl ch9121_fascia_stencil.stl ch9121_mount.scad -D 'part="stencil"'
stl ch9121_rj45_cutter.stl    ch9121_mount.scad -D 'part="cutter"'
stl pi5_ch9121_1u.stl         pi5_ch9121_1u.scad
stl pi5_ch9121_1u_coupon.stl  pi5_ch9121_1u.scad -D 'part="coupon"'

echo "Renders:"
png iso.png       ch9121_mount.scad 1100 880 Tomorrow "$CARRIER_ISO"
png fit.png       ch9121_mount.scad 1100 880 Tomorrow "$CARRIER_ISO" \
                  -D show_reference=true
png underside.png ch9121_mount.scad 1000 800 Tomorrow "$CARRIER_UNDER"
png flange.png    ch9121_mount.scad  700 650 Tomorrow "$FRONT" --projection=o
png stencil.png   ch9121_mount.scad  700 650 Tomorrow "$FRONT" --projection=o \
                  -D 'part="stencil"'

png panel_iso.png   pi5_ch9121_1u.scad 1600 900 Cornfield "$PANEL_ISO"
png panel_fit.png   pi5_ch9121_1u.scad 1600 900 Cornfield "$PANEL_ISO" \
                    -D show_reference=true
png panel_front.png pi5_ch9121_1u.scad 1600 400 Cornfield "$FRONT" \
                    --projection=o

echo "done"
