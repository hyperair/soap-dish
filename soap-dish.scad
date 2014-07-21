include <MCAD/units/metric.scad>
use <suction-cup.scad>

module drainage_holes (width, length, number, spacing)
{
    translate ([-(spacing + width) * number / 2, 0, 0])
    for (i = [0:number]) {
        translate ([(spacing + width) * i, 0, 0])
        hull () {
            translate ([0, -length/2, 0])
            circle (d=width);

            translate ([0, length/2, 0])
            circle (d=width);
        }
    }
}

module dishify (
    wall_thickness = length_mm (3),
    floor_thickness = length_mm (3),
    height = length_mm (10),
    fillet_radius = length_mm (1),
    hole_width = length_mm (5),
    hole_length = length_mm (40),
    hole_spacing = length_mm (7)
)
{
    difference () {
        // main block
        linear_extrude (height)
        difference () {
            offset (wall_thickness)
            children ();

            intersection () {
                drainage_holes (
                    width = hole_width,
                    length = hole_length,
                    number = 7,
                    spacing = hole_spacing
                );
                children ();
            }
        }


        // dish cutout
        translate ([0, 0, floor_thickness + fillet_radius])
        minkowski () {
            linear_extrude (height - floor_thickness + epsilon - fillet_radius)
            offset (-fillet_radius)
            children ();

            sphere (r=fillet_radius);
        }
    }
}

module soap_dish_shape (
    rounding_radius = length_mm (10),
    width = length_cm (10),
    height = length_cm (5)
)
{
    centre_width = width - rounding_radius * 2;
    centre_height = height - rounding_radius * 2;

    hull () {
        translate ([-centre_width / 2, centre_height / 2])
        circle (r=rounding_radius);

        translate ([centre_width / 2, -centre_height / 2])
        circle (r=rounding_radius);

        translate ([centre_width / 2, centre_height / 2])
        circle (r=rounding_radius);

        translate ([-centre_width / 2, -centre_height / 2])
        circle (r=rounding_radius);
    }
}

module mounting_arm (
    cup_offset = length_mm (25),
    wall_thickness = length_mm (5)
)
{
    width = cup_offset;

    difference () {
        hull () {
            translate ([-width/2, 0, 0])
            cube ([width, width, wall_thickness]);

            translate ([0, cup_offset, 0])
            cylinder (d=width, h=wall_thickness);
        }

        translate ([0, cup_offset / 2, length_mm (5.5)])
        mirror ([0, 0, 1])
        rotate ([0, 0, 90])
        suction_cup_mount_cutout ();
    }
}

module soap_dish (
    rounding_radius = length_mm (10),
    inner_width = length_cm (10),
    inner_height = length_cm (5),
    height = length_mm (10),
    wall_thickness = length_mm (5),
    floor_thickness = length_mm (5),
    fillet_radius = length_mm (1),
    hole_diameter = length_mm (5),
    suction_cup_distance = length_mm (55), // distance between centres
    suction_cup_wall_offset = length_mm (3.5),
    mode = "assembly"
)
{
    // main soap dish
    dishify (
        wall_thickness = wall_thickness,
        floor_thickness = floor_thickness,
        height = height,
        fillet_radius = fillet_radius,
        hole_diameter = hole_diameter
    )
    soap_dish_shape (
        rounding_radius = rounding_radius,
        width = inner_width,
        height = inner_height
    );

    // shim to compensate for suction cup distance to wall
    translate ([-inner_width/4, inner_height/2 + wall_thickness, 0])
    cube ([inner_width/2, suction_cup_wall_offset, floor_thickness]);

    // mounting arms
    module arms () {
        translate ([-suction_cup_distance / 2, 0, 0])
        mounting_arm ();

        translate ([suction_cup_distance / 2, 0, 0])
        mounting_arm ();
    }

    if (mode == "assembly") {
        translate ([0, inner_height/2 + wall_thickness, height - epsilon])
        rotate ([90, 0, 0])
        arms ();
    } else {
        translate ([0, inner_height / 2 + wall_thickness + length_mm (10), 0])
        arms ();
    }
}

soap_dish (mode = "plate");
