use <icons.scad>;
$fn=$preview?32:256;


module C(){
projection(){
render()difference(){
    cylinder(d=135);
    cylinder(d=71);
    translate([1000+88-135/2,0,0])cube(2000,center=true);
    
}


}
}
module button(x=false,y=false,a=false,b=false){
translate([88-135/2+36,0,0])scale(2)snesbuttons(x,y,a,b);
}







