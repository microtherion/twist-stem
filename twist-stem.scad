/*
 * Twist-Stem twisting interlocking mechanism
 *
 * Copyright (C) 2023 Matthias Neeracher <microtherion@gmail.com>
 */

$fn = $preview ? 32 : 64;

module _twist_stem_funnel(width, height, stem, wedge, wall, htol, vtol, pinch) {
    r = 0.5*(stem+htol);
    pd = stem-pinch;
    h = sqrt(r*r-0.25*pd*pd);
    v = (0.5*width-wall)*sin(0.5*wedge)+0.5*htol;
    o = (0.5*width-wall)*cos(0.5*wedge);
    translate([0, 0, wall]) linear_extrude(height+vtol-2*wall) polygon([[-0.5*width, -v], [-o, -v], [-h, -0.5*pd], [-h, 0.5*pd], [-o, v], [-0.5*width, v]]);
    translate([0, 0, height+vtol-wall]) linear_extrude(wall) polygon([[-0.5*width, -r], [-h, -0.5*pd], [-h, 0.5*pd], [-0.5*width, r]]);
}

module twist_stem_base(width, height, stem, wedge=90, wall=2.0, htol=0.5, vtol=0.5, pinch=0.5) {
    difference() {
        translate([-0.5*width, -0.5*width, 0]) cube([width, width, height]);
        translate([0, 0, wall]) cylinder(height, d=stem+htol);
        translate([0, 0, wall]) rotate([0, 0, 90-0.5*wedge]) rotate_extrude(angle=90+wedge+2.5) square([0.5*(width+htol)-wall, height+vtol-2*wall]);
        _twist_stem_funnel(width, height, stem, wedge, wall, htol, vtol, pinch);
    }
}

module twist_stem_insert(width, height, stem, wedge=90, wall=2.0, vtol=0.5) {
    cylinder(height-wall+vtol, d=stem);
    rotate([0, 0, 180-0.5*wedge]) rotate_extrude(angle=wedge) square([0.5*width-wall, height-2*wall]);
}

function twist_stem_insert_height(height, wall=2.0, vtol=0.5) = height-wall+vtol;

module twist_stem_demo_project(width, height, stem) {
    insert_width=stem+3;
    twist_stem_base(width, height, stem);
    translate([width+5, 0, 0]) {
        twist_stem_insert(width, height, stem);
        translate([-0.5*insert_width, -0.5*insert_width, twist_stem_insert_height(height)]) cube([insert_width, insert_width, 5]);
    }
}

twist_stem_demo_project(width=15, height=8, stem=5);
