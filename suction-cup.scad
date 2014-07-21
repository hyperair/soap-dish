include <MCAD/units/metric.scad>

module suction_cup (
    height = length_mm (10),
    mount_diameter = length_mm (15),
    mount_gap_diameter = length_mm (15 - 3*2),
    mount_gap_thickness = length_mm (2.5),
    mount_gap_elevation = length_mm (2),
    centre_hole_diameter = length_mm (6),
    centre_hole_depth = length_mm (2),
    cup_diameter = length_mm (49),
    cup_inner_thickness = length_mm (2),
    cup_outer_thickness = length_mm (1)
)
{
    mount_height = height - cup_thickness;

    // cup
    translate ([0, 0, cup_outer_thickness])
    cylinder (
        d1 = cup_diameter,
        d2 = mount_diameter,
        h = cup_inner_thickness - cup_outer_thickness + epsilon
    );

    cylinder (
        d = cup_diameter,
        h = cup_outer_thickness
    );

    // mount
    difference () {
        // main mount body
        cylinder (
            d = mount_diameter,
            h = height
        );

        // gap to be cut out
        translate ([0, 0, cup_inner_thickness + mount_gap_elevation])
        linear_extrude (mount_gap_thickness)
        difference () {
            circle (d = mount_diameter + epsilon);
            circle (d = mount_gap_diameter);
        }

        // centre hole
        translate ([0, 0, height - centre_hole_depth + epsilon])
        cylinder (
            d = centre_hole_diameter,
            h = centre_hole_depth + epsilon
        );
    }
}

module suction_cup_mount_cutout (
    head_diameter = length_mm (15), //match the mount_diameter
    head_height = length_mm (3),
    shaft_diameter = length_mm (15 - 3*2),
    shaft_height = length_mm (2.5)
)
{
    height = head_height + shaft_height;

    // track for the head to move in
    hull () {
        cylinder (
            d = head_diameter,
            h = head_height
        );

        translate ([head_diameter, 0, 0])
        cylinder (
            d = head_diameter,
            h = head_height
        );
    }

    // track for the gap
    hull () {
        cylinder (
            d = shaft_diameter,
            h = height
        );

        translate ([head_diameter, 0, 0])
        cylinder (
            d = shaft_diameter,
            h = height
        );
    }

    // insertion hole for head
    cylinder (
        d = head_diameter,
        h = height
    );
}

%suction_cup ();

difference () {
    translate ([0, 0, 5])
    cube ([40, 40, 10], center=true);

    translate ([0, 0, 5.5])
    mirror ([0, 0, 1])
    suction_cup_mount_cutout ();
}
