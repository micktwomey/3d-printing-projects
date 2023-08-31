include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

// Smoothness of output
$fn = 64;

// Radius of hole (will subtract plug wall)
hole_diameter = 25;
radius = hole_diameter / 2;

// plug wall thickness
plug_wall_thickness = 2;

// Debug: Show some plug wall?
show_plug_wall = false;

// Debug: Show the hole?
show_hole = false;

// Hollow out the tube?
hollow_tube = true;

// Tube depth
tube_depth = 10;

adjusted_radius = radius - plug_wall_thickness;


// Cable diameters, each number in array is a cable
cable_diameters = [8, 6];



// Intersects with plug to form guide for cable
module cable_hole(diameter=10) {
    translate([0, 0, -2]) cylinder(h=30, d=diameter);
    translate([-(diameter/2), 0, -2]) cube([diameter, diameter*2, 30]);
}

// Builds a series of holes to intersect with other shapes
module cable_holes(cable_diameters) {
    cable_count = len(cable_diameters);
    assert(cable_count > 0);
    for(cable_i=[0:cable_count-1]) {
        assert(cable_i >= 0);
        assert(cable_i < cable_count);
        cable_diameter = cable_diameters[cable_i];
        rotate([0, 0, cable_i * (360 / cable_count)])
        translate([0, adjusted_radius - (cable_diameter/2), 0])
        cable_hole(diameter=cable_diameter);
    }
}

module cover() {

    difference() {
        // Add a cap to stop cylinder falling into hole
        union() {
            cylinder(h=tube_depth, r=adjusted_radius);
    //        translate([0, 0, 20]) cylinder(h=1, d=hole_diameter+1);
            translate([0, 0, tube_depth])
                rotate_extrude(convexity=10, angle=360)
                translate([(radius/2), 0, 0])
                rect([radius, 1], rounding=[0.5, 0, 0, 0.5]);
        }

        if (hollow_tube) {
            translate([0, 0, -1]) cylinder(h=tube_depth-1, r=adjusted_radius-2);
        }

        cable_holes(cable_diameters=cable_diameters);

    }


    if (show_hole) {
        color("green",0.5) cylinder(h=10, d=hole_diameter);
    }

    if (show_plug_wall) {
        color("blue",0.5) rotate_extrude(convexity=10, angle=240)
            translate([(radius - 4 / 2), 0, 0])
            square([2, 20]);
    }
}

translate([0, 0, 10.5]) rotate([0, 180, 0]) cover();
