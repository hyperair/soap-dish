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

suction_cup ();
