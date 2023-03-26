$fn = $preview ? 64 : 128;

module dpad() {
  difference() {
    for (r = [ 0, 90 ]) rotate([ 0, 0, r ]) hull() {
        for (x = [ 0.5, -0.5 ])
          for (y = [ 0.5, -0.5 ]) translate([ x * 23, y * 8.5, 0 ]) cylinder(d = 1, h = 1);
      }
    cylinder(d = 5, h = 1);
    hull() {
      translate([ 0, 10.5, 0 ]) cylinder(d = 1, h = 1);
      translate([ 2.5, 5, 0 ]) cylinder(d = 1, h = 1);
      translate([ -2.5, 5, 0 ]) cylinder(d = 1, h = 1);
    }
  }
}

module snesbuttons(x = false, y = false, a = false, b = false) {
  if (a) projection() translate([ 13, 0, 0 ]) cylinder(d = 10);
  if (y) projection() translate([ -13, 0, 0 ]) cylinder(d = 10);
  if (x) projection() translate([ 0, 13, 0 ]) cylinder(d = 10);
  if (b) projection() translate([ 0, -13, 0 ]) cylinder(d = 10);
}
module fireButton(char) {
  //% circle(d = 35);
  case_r = 5;
  btn_w = 20;
  btn_h = 8;
  cut_d = 150;
  cut_h = cut_d / 2 - 1;
  text_h_offset = -1;
  text_block_size = 1.2;
  text_block_size_x = 0.937 * text_block_size;
  text_block_size_y = text_block_size;

  for (x = [0:1:7])
    for (y = [0:1:7])
      if (char[x][y]) translate([ -4 * text_block_size_x + x * text_block_size_x, text_block_size_y * -y + 8 * text_block_size_y + text_h_offset, 0 ]) scale([ 1.5, 1.5, 1 ]) cube([ text_block_size_x, text_block_size_y, 1 ]);

  difference() {
    translate([ -btn_w / 2, -btn_h, 0 ]) cube([ btn_w, btn_h, 1 ]);
    translate([ 0, cut_h, 0 ]) cylinder(d = cut_d, h = 1);
  }
  for (m = [ 0, 1 ]) mirror([ m, 0, 0 ]) translate([ btn_w / 2, -btn_h, 0 ]) intersection() {
      cylinder(r = case_r);
      cube(case_r);
    }
}

module joystick(dir = 0) {
  //% circle(d = 35);
  translate([ -10, 0, 0 ]) rotate([ 0, 0, 90 * dir ]) translate([ 0, 1, 0 ]) union() {
    hull() {
      translate([ 0, 4, 0 ]) cylinder(d = 1, h = 1);
      translate([ 2.5, -1, 0 ]) cylinder(d = 1, h = 1);
      translate([ -2.5, -1, 0 ]) cylinder(d = 1, h = 1);
    }
    hull() {
      translate([ 1, 0, 0 ]) cylinder(d = 1, h = 1);
      translate([ -1, 0, 0 ]) cylinder(d = 1, h = 1);
      translate([ 1.5, -4, 0 ]) cylinder(d = 1, h = 1);
      translate([ -1.5, -4, 0 ]) cylinder(d = 1, h = 1);
    }
  }
  translate([ 2, 0, 0 ]) union() {
    translate([ 0, 6, 0 ]) cylinder(d = 7);
    hull() {
      translate([ 0, 6, 0 ]) cube([ 4, 1, 1 ], center = true);
      translate([ 0, -5, 0 ]) cube([ 3, 1, 1 ], center = true);
    }
    translate([ 0, -6, 0 ]) cube([ 5, 1, 1 ], center = true);
    translate([ 0, -8, 0 ]) cube([ 8, 3, 1 ], center = true);
  }
}

module shoulder(text = "") {
  difference() {
    hull() for (x = [ -.5, .5 ]) translate([ 20 * x, 0, 0 ]) cylinder(d = 7, h = 1);
    tm = textmetrics(text, 5);

    translate([ -tm.position[0] - tm.size[0] / 2, -tm.position[1] - tm.size[1] / 2, 0 ]) linear_extrude(1) text(text, 5);
  }
}
module led(num, lid = true) {
  % circle(d = 35);
  difference() {
    union() {
      hull() {
        cylinder(d = 12, h = 1);
        translate([ 0, -7, 0.5 ]) cube([ 12, 1, 1 ], center = true);
      }
      translate([ 0, -7, 0.5 ]) cube([ 15, 1, 1 ], center = true);
    }
    tm = textmetrics(num, 5);

    translate([ -tm.position[0] - tm.size[0] / 2, -tm.position[1] - tm.size[1] / 2 - 1, 0 ]) linear_extrude(1) text(num, 5);
  }

  if (lid)
    for (r = [ -30, 0, 30]) rotate([ 0, 0, r ]) hull() {
        translate([ 0, 8, 0 ]) cylinder(d = 1, h = 1);
        translate([ 0, 15, 0 ]) cylinder(d = 1, h = 1);
      }
}

module stasel(s) {
  % circle(d = 35);
  for (x = [ 0, 1 ]) translate([ x * 17 - 13, -2, 0 ]) hull() {
      cylinder(d = 4);
      translate([ 9, 9, 0 ]) cylinder(d = 4);
    }
  tm = textmetrics(s, 5);

  translate([ -tm.position[0] - tm.size[0] / 2, -tm.position[1] - tm.size[1] / 2 - 8, 0 ]) linear_extrude(1) text(s, 5);
}


/**exporter
***snes_start
!projection()stasel("START");
,***snes_select
!projection()stasel("SELECT");
***led_1_on
!projection()led("1",true);
***led_1_off
!projection()led("1",false);
***led_2_on
!projection()led("2",true);
***led_2_off
!projection()led("2",false);
***snes_shoulder_l
!projection()shoulder("L");
***snes_shoulder_R
!projection()shoulder("R");
***dpad_up
!projection()dpad();
***dpad_down
!projection()rotate([0,0,180])dpad();
***dpad_left
!projection()rotate([0,0,90])dpad();
*,**dpad_right
!proje,ction()rotate([0,0,-90])dpad();
***snes_button_a
!snesbuttons(a=true);
***snes_button_b
!snesbuttons(b=true);
***snes_button_x
!snesbuttons(x=true);
***snes_button_y
!snesbuttons(y=true);
***c64_joy_up
!projection()joystick(0);
***c64_joy_down
!projection()joystick(2);
***c64_joy_left
!projection()joystick(1);
***c64_joy_right
!projection()joystick(3);
***c64_btn_1
!projection()fireButton([[false,false,false,false,false,false,false,false],[false,false,false,false,false,false,true,false],[false,false,true,false,false,false,true,false],[true,true,true,true,true,true,true,false],[true,true,true,true,true,true,true,false],[false,false,false,false,false,false,true,false],[false,false,false,false,false,false,true,false],[false,false,false,false,false,false,false,false]]);
***c64_btn_2
!projection()fireButton([[false,false,false,false,false,false,false,false],[false,true,false,false,false,true,true,false],[true,true,false,false,true,true,true,false],[true,false,false,false,true,false,true,false],[true,false,false,true,false,false,true,false],[true,true,true,true,false,false,true,false],[false,true,true,false,false,false,true,false],[false,false,false,false,false,false,false,false]]);
***c64_btn_3
!projection()fireButton([[false,false,false,false,false,false,false,false],[false,true,false,false,false,true,false,false],[true,true,false,false,false,true,true,false],[true,false,false,true,false,false,true,false],[true,false,false,true,false,false,true,false],[true,true,true,true,true,true,true,false],[false,true,true,false,true,true,false,false],[false,false,false,false,false,false,false,false]]);
***c64_btn_a
!projection()fireButton([[false,false,false,false,false,false,false,fals,e],[false,false,true,true,true,true,true,false],[false,true,true,true,true,true,true,false],[true,true,false,true,false,false,false,false],[true,true,false,true,false,false,false,false],[false,true,true,true,true,true,true,false],[false,false,true,true,true,true,true,false],[false,false,false,false,false,false,false,false]]);
**/