include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

// Smoothness of output
$fn = 64;

// Debug: Show some sample cables?
show_cables = false;

// Debug: Show the hole?
show_hole = false;

// Fill the hole with a solid plate?
solid_plate = false;

// Diameter of hole to put plug into
hole_diameter = 25;

// Use 120 for 1/3, or 120 and 240 for 1/3 and 2/3. Use 360 for a full plug.
angle = 120;

module tube(h=10, d=10, wall_thickness=1, center=false) {

    difference() {
        cylinder(h=h, d=d, center=center);
        cylinder(h=h+2, d=d-wall_thickness, center=center);
    }
}

module plug(diameter, angle, solid_plate=false) {
    radius = diameter / 2;
    convexity = 10;
    // bevel around edge
    rotate_extrude(convexity = convexity, angle=angle)
        translate([radius+3, 0, 0])
        rect([10, 2], rounding=[0.5, 0, 0.5, 0.5]);
    // inner tube
    rotate_extrude(convexity = convexity, angle=angle)
        translate([(radius - 4 / 2), 0, 0])
        square([2, 20]);

    // inner plate
    if (solid_plate) {
        translate([0, 0, -1])
            rotate_extrude(convexity = convexity, angle=angle)
            square([radius, 2]);
    }
}

plug(diameter=hole_diameter, angle=angle, solid_plate=solid_plate);




if (show_hole) {
    color("green",0.5) translate([0, 0, 1.5]) cylinder(h=10, d=hole_diameter);
}

if (show_cables) {
    color("red",0.5) translate([-5, 0, -15]) cylinder(h=60, d=5);
    color("red",0.5) translate([5, 0, -15]) cylinder(h=60, d=5);
    color("red",0.5) translate([0, -5, -15]) cylinder(h=60, d=5);
}
