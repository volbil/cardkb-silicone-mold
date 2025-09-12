module clear_reference() {
    import("membrane_no_text.3mf");
}

module letter(symbol, font_size=4) {
    linear_extrude(1)
    text(symbol, font="Open Gorton:style=Bold", size=font_size, $fn=50);
}

module reference_letters() {
    union() {
        clear_reference();

        // First row
        translate([-30, 1, 7])
            letter("1");

        translate([-24.7, 1, 7])
            letter("2");

        translate([-18.5, 1, 7])
            letter("3");

        translate([-12.8, 1, 7])
            letter("4");

        translate([-6.5, 1, 7])
            letter("5");

        translate([-0.8, 1, 7])
            letter("6");

        translate([5.3, 1, 7])
            letter("7");

        translate([11.2, 1, 7])
            letter("8");

        translate([17.2, 1, 7])
            letter("9");

        translate([23.1, 1, 7])
            letter("0");

        // Second row
        translate([-31.65, -11.1, 7])
            letter("Q");

        translate([-25.65, -11.1, 7])
            letter("W");

        translate([-18.65, -11.1, 7])
            letter("E");

        translate([-12.65, -11.1, 7])
            letter("R");

        translate([-6.8, -11.1, 7])
            letter("T");

        translate([-0.8, -11.1, 7])
            letter("Y");

        translate([5, -11.1, 7])
            letter("U");

        translate([12.3, -11.1, 7])
            letter("I");

        translate([16.7, -11.1, 7])
            letter("O");

        translate([23.5, -11.1, 7])
            letter("P");

        // Third row
        translate([-25.2, -23.1, 7])
            letter("A");

        translate([-19.1, -23.1, 7])
            letter("S");

        translate([-12.95, -23.1, 7])
            letter("D");

        translate([-6.5, -23.1, 7])
            letter("F");

        translate([-6.5, -23.1, 7])
            letter("F");

        translate([-1.25, -23.1, 7])
            letter("G");

        translate([5, -23.1, 7])
            letter("H");

        translate([11, -23.1, 7])
            letter("J");

        translate([17, -23.1, 7])
            letter("K");

        translate([23.5, -23.1, 7])
            letter("L");

        // Fourth row
        translate([-25, -35.1, 7])
            letter("Z");

        translate([-19, -35.1, 7])
            letter("X");

        translate([-13.2, -35.1, 7])
            letter("C");

        translate([-7.2, -35.1, 7])
            letter("V");

        translate([-0.6, -35.1, 7])
            letter("B");

        translate([5.1, -35.1, 7])
            letter("N");

        translate([10.7, -35.1, 7])
            letter("M");

        translate([18, -33.1, 7])
            letter(",", 7);

        translate([24, -33.4, 7])
            letter(".", 7);

        // Arrows
        translate([-36.5, -31.1, 7])
            letter(">");

        translate([-39.4, -26.1, 7])
            rotate([0, 0, 90])
                letter(">");

        translate([-48.5, -31.1, 7])
            letter("<");

        translate([-39.4, -36.1, 7])
            rotate([0, 0, 90])
                letter("<");
    }
}

module reference() {
    rotate([180,0,0])
        reference_letters();
}

module main_model() {
    difference() {
        translate([-53, -17, -9])
            cube([90, 60, 8]);
        
        reference();
    }
}

module sliced_model_bottom() {
    translate([53, 17, 9]) {
        intersection() {
            main_model();
            translate([-60, -40, -10])
                cube([100, 100, 5]);
        }
    }
}

module sliced_model_top() {
    translate([37, 17, -1]) {
        rotate([0, 180, 0]) {
            intersection() {
                main_model();
                translate([-60, -40, -5])
                    cube([100, 100, 5]);
            }
        }
    }
}

module bezel() {
    translate([0, 0, -1.2]) {
        difference() {
            difference() {
                difference() {
                    mirror([1, 0, 0]) {
                        translate([-90, 0, 0]) {
                            sliced_model_top();
                        }
                    }

                    cube([90, 60, 1.2]);
                }

                difference() {
                    translate([14.5, 9, 0]) {
                        cube([73, 46, 5]);
                    }

                    translate([17, 33, 0]) {
                        cube([3, 5, 5]);
                    }
                }
            }

            translate([3, 25.5, 0]) {
                cube([14.4, 30, 5]);
            }
        }
    }
}

module sliced_model_bottom_bezel() {
    union() {
        translate([0, 0, 4]) {
            bezel();
        }

        sliced_model_bottom();
    }
}

module sliced_model_top_no_bezel() {
    difference() {
        sliced_model_top();

        translate([90, 0, 1.2]) {
            rotate([0, 0, 0]) {
                mirror([180, 0, 0]) {
                    bezel();
                }
            }
        }
    }
}

module sliced_model_top_no_bezel_stift() {
    module stift() {
        cylinder(h=5, r=1.3, $fn = 6);
    }

    sliced_model_top_no_bezel();

    translate([2, 2, 0]) { 
        stift();
    }

    translate([88, 2, 0]) { 
        stift();
    }

    translate([2, 58, 0]) { 
        stift();
    }

    translate([88, 58, 0]) { 
        stift();
    }
}

module sliced_model_bottom_bezel_holes() {
    difference() {
        sliced_model_bottom_bezel();
        translate([90, 0, 8]) {
            rotate([0, 180, 0]) {
                mirror([0, 0, 0]) {
                    sliced_model_top_no_bezel_stift();
                }
            }
        }
    }
}


sliced_model_bottom_bezel_holes();

translate([0, 70, 0]) {
    sliced_model_top_no_bezel_stift();
}


// translate([16, 65, 10]) {
//     sliced_model_top();
// }

// rotate([0, 180, 0]) {
//     translate([16, 65, 10]) {
//         sliced_model_top();
//     }
// }