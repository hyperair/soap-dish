include <MCAD/units/metric.scad>

module drainage_holes (d, spacing, bounding_box=[500, 500])
{
    holes_x = floor (bounding_box[0] / (spacing + d));
    holes_y = floor (bounding_box[1] / (spacing + d));

    res = spacing + d;

    for (x=[(-holes_x/2):(holes_x/2)])
    for (y=[(-holes_y/2):(holes_y/2)]) {
        if (y % 2 == 0) {
            translate ([x * res + res * 1.5, y * res])
            circle (d = d);
        } else {
            translate ([x * res, y * res])
            circle (d = d);
        }
    }
}

module dishify (
    wall_thickness = length_mm (3),
    floor_thickness = length_mm (3),
    height = length_mm (10),
    fillet_radius = length_mm (1),
    hole_diameter = length_mm (5)
)
{
    difference () {
        // main block
        linear_extrude (height)
        difference () {
            offset (wall_thickness)
            children ();

            intersection () {
                drainage_holes (d=hole_diameter, spacing=hole_diameter / 2);
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

dishify ()
soap_dish_shape ();
