var params = {
    side1:20,
    side2:30,
    side3:6,
    side4:-1
}
    function main() {
        var hinge = mathhinge();
        hinge = hinge.scale([0.5,0.5,0.5])

        var legnth1, length2, length3, length4;

            if (params.side1 != 'none') { //bottom
                length1 = params.side1
                 var bar1 = cube({size:[10,length1,1.5]})
            }

            if (params.side2 != 'none') { //bottom
               length2 = params.side2
                var bar2 = cube({size:[10,length2,1.5]})
            }

            if(params.side3 != 'none'){
                length3 = params.side3
                var bar3 = cube({size:[10,length3,1.5]})
            }
            
            if(params.side4 != 'none'){
                length4 = params.side4
                var bar4 = cube({size:[10,length4,1.5]})

                bar4 = difference(
                        bar4
                        ,cylinder({r:1,h:4}).translate([5,2,0.5])
                )
            }

            var line = union(
                bar1
                ,hinge.translate([0,length1+3,0])
                            
                ,bar2.translate([0,length1+6,0])
                ,hinge.translate([0,length1+length2+9,0])
            );

            if (params.side4 != -1){

                line = union(
                    line
                    ,bar3.translate([0,length1+length2+12,0])

                    ,hinge.translate([0,length1+length2+length3+15,0])
                    ,bar4.translate([0,length1+length2+length3+18,0])
                );
            } else if(params.side4 === -1){
                bar3 = difference(
                        bar3
                        ,cylinder({r:1.2,h:4}).translate([5,2,0])
                        ,cylinder({r:1,h:4}).translate([1.7,2,0.5])
                    )
                line = union(
                    line
                    ,bar3.translate([0,length1+length2+12,0])
                )
            }

            return line;

        } // end of main
        
        function mathhinge(){

            length = 20; // Length of the complete hinge
            height = 3; // Height (diameter) of the hinge
            clearance = 0.3; // Clearance between cones and holes   
            gap = 0.6; // Clearance between hinge and sides             

            // Parameters that the user does not get to specify
            fn=24*1;
            border = 2*1; 
            fudge = .01*1;          // to preserve mesh integrity
            corner = 0*1;       // space between hinge and corner
            hinge_radius = height/2;
            cone_height = 1.5*hinge_radius;  


            var hinge_module = hinge(hinge_radius, clearance, length, corner, cone_height)
                                .translate([-hinge_radius,0,0])
                                .rotateY(90);

            var bar1 = bar(length, border, height)
                        .translate([0, hinge_radius+gap, 0]);
            var bar2 = bar(length, border, height)
                        .translate([0, -2*border-hinge_radius-gap, 0]);

            return union(hinge_module, bar1, bar2);

        }

        function hinge(hinge_radius, clearance, 
                        length, corner, cone_height){
            rad = hinge_radius;
            clr = clearance;
            len = (length-2*corner)/3; 
            con = cone_height;
            // left outside hinge = (cylinder+box)-cone
            var outside = difference(
                            union(
                                cylinder({h:len-clr,r:rad})
                                    .translate([0,0,corner]),
                                cube([2*rad,rad+gap,len-clr])
                                    .translate([-rad,0,corner])
                                ),
                                cylinder({h:con,r1:0,r2:rad})
                                    .translate([0,0,corner+len-con-clr+fudge])
            )
            // inside hinge = cylinder+box+cone+cone
            var inside = union(
                            cylinder({h:len,r:rad})
                                .translate([0,0,corner+len]),
                            cube([2*rad,rad+gap,len])
                                .translate([-rad,-rad-gap,corner+len]),
                            cylinder({h:con,r1:0,r2:rad})
                                .translate([0,0,corner+len-con]),
                            cylinder({h:con,r1:rad,r2:0})
                                .translate([0,0,corner+2*len])
                            );
            
            // right outside hinge = (cylinder+box)-cone
            var right = union(
                            cylinder({h:len-clr,r:rad})
                                .translate([0,0,corner+2*len+clr]),
                            cube([2*rad,rad+gap,len-clr])
                                .translate([-rad,0,corner+2*len+clr])
                        );
                right = difference(
                            right,
                            cylinder({h:con,r1:rad,r2:0})
                                .translate([0,0,corner+2*len+clr-fudge])
                        );
            
            return union(outside, inside, right);
        }

        function bar(length, border, height){
            return cube([length,2*border,height]);
        }
