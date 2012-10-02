//
// I was not content with the lightning adapter posted to the thingiverse since
// I had come up with what I think of as a better cutout for the lightning
// plug. So I am extending thing xxx with this model instead.
//

use <Libs.scad>;

padding = 0.1;

// Lightning plug dimensions
//
lightning_w = 8.2;
lightning_d = 5;
lightning_h = 12;
lightning_cable_r = 2.5/2;
lightning_strain_relief_r = 4.1/2;


// How much more it leans back from perfectly 90 up
//
plug_angle = -9; // -8;

// thickness of the base this is all mounted on
//
base_thickness = 2;
base_width = 46;
base_depth = 9.4;
bolt_offset = 18;
bolt_r = 3.2/2; // M3 bolt

plug_width = 26.9;
plug_depth = 6.3;
// plug_height = 8.13;
plug_height = lightning_h - base_thickness;

/////////////////////////////////////////////////////////////////////////////
//
// Like the headphone plug we need a shape sized to the lightning connector
// with a nice tight fit. It is actually oval shaped, but a rounded rectangle
// is good enough since the size is small and we want a tight fit.
//
module lightning_plug() {
    translate( v = [0,0,lightning_h/2] ) {
        roundRect( size = [lightning_w, lightning_d, lightning_h],
            round = lightning_d / 2, center = true);
    }
}

/////////////////////////////////////////////////////////////////////////////
//
// the cut out for the lightning cable.
//
module lightning_cable_cutout(height) {
    translate( v = [0,0,height/2] ) {
        union() {
            cylinder( h = height, r = lightning_strain_relief_r, center = true, $fn = 16 );
            translate( v = [0,-(height/2),0]) {
                cube([lightning_cable_r*2, height, height], true);
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////////////
//
// The base that snaps in to the elevation dock.
//
module elevation_dock_adapter() {
    difference() {
        union() {
            translate( v = [0,0,base_thickness/2]) {
                difference() {
                    roundRect( size = [base_width, base_depth, base_thickness], round = base_depth / 2, center = true );
                    // cube([base_width, base_depth, base_thickness], true);
                    translate( v = [0, -7.65, -((base_thickness/2)+padding)]) {
                        cylinder( h = base_thickness + (padding*2), r = 4.7, $fn = 25 );
                    }
                }

            }
            rotate([plug_angle, 0,0]) {
                translate( v = [0,0, base_thickness] ) {
                    translate( v = [0,0, (plug_height / 2)]) {
                        roundRect( size = [ plug_width, plug_depth, plug_height + 1 ],
                            round = plug_depth / 2, center = true );
                    }
                }
            }
        }

        // The lightning plug shoots up the middle at the same angle as the
        // plug.
        //
        rotate([plug_angle, 0,0]) {
            translate( v = [0,0,0.6] ) {
                lightning_plug();
            }
        }

        // and we have bolt holes on either side of the base..
        //
        translate( v = [-bolt_offset, 0, -padding] ) {
            cylinder( r = bolt_r, h = 10, $fn = 25 );
        }
        translate( v = [bolt_offset, 0, -padding] ) {
            cylinder( r = bolt_r, h = 10, $fn = 25 );
        }

        // And a notch cut out of the side for us to run our cable through.
        //
        rotate([plug_angle, 0, 0]) {
            translate( v = [0,4,0]) {
                cube([lightning_cable_r*2, 8, 30], true);
            }
            translate( v = [0,0,-5]) {
                cylinder(h=10,r=lightning_strain_relief_r, $fn = 25);
            }
        }
    }
}

// lightning_plug();
elevation_dock_adapter();
