// ----------------------------------------------------------------------------------
// Print settings:
// - Infill: 15% (or less if bridges OK)
// ----------------------------------------------------------------------------------
include<../modules/printer_limits.scad>
use<../modules/enclosure_box.scad>
// ----------------------------------------------------------------------------------
// DIMENSIONS
artys7_wall_width = ptr_wall_width;
artys7_bottom_wall_width = z_dim_adj(2);

artys7_screws_hide_offset = z_dim_adj(xy_screw_3mm_hd_h + 3);

artys7_l = 111;
artys7_w = 86;
artys7_h = z_dim_adj(15 + artys7_screws_hide_offset) ;
artys7_board_bt_clearence = z_dim_adj(4 + artys7_screws_hide_offset);
artys7_lid_h = z_dim_adj(6);

// ------------------------------------------
// Screws
artys7_screws_xy = [
  [            3*artys7_wall_width, 3*artys7_wall_width],
  [artys7_l - 1*artys7_wall_width, 3*artys7_wall_width],
  [            3*artys7_wall_width, artys7_w-1*artys7_wall_width],
  [artys7_l - 1*artys7_wall_width, artys7_w-1*artys7_wall_width]
];

// ------------------------------------------
// Connectors - Bottom
artys7_bottom_connectors = [
  [ [35, 0], 34 ]
]

// ------------------------------------------
// Connectors - Top

// ------------------------------------------
module artys7_enclosure(
  fitted_lid=true,
  draw_lid=false,
  draw_container=false,
  draw_as_close_box=false
)
{
  echo("----------------------------------------------------------------------------------------------------------------------------------------------------");
  echo("ARTY-S7 Enclosure");
  if(draw_container || draw_as_close_box ) {
    difference() {
      enclosure_box(
        length=artys7_l, width=artys7_w, height=artys7_h, lid_height=artys7_lid_h,
        xy_wall_width=artys7_wall_width, z_wall_width=artys7_bottom_wall_width,
        fitted_lid=fitted_lid, draw_container=true,
        xy_screws=[xy_screw_3mm_d, artys7_screws_xy],
        xy_screws_hide=[xy_screw_3mm_hd_d, artys7_screws_hide_offset],
        tolerance=ptr_tolerance
      );
      translate([1+artys7_wall_width, -artys7_wall_width, artys7_bottom_wall_width+artys7_board_bt_clearence])
        cube([36, 3*artys7_wall_width, artys7_h+artys7_bottom_wall_width]);
    }
  }
  if(draw_lid || draw_as_close_box) {
    rotate(enclosure_close_box_lid_rotate_ang(draw_as_close_box))
      translate(enclosure_close_box_lid_translate_xyz(draw_as_close_box=draw_as_close_box, length=artys7_l, width=artys7_w, height=artys7_h, xy_wall_width=artys7_wall_width, z_wall_width=artys7_bottom_wall_width))
        difference() {
          enclosure_box(
            length=artys7_l, width=artys7_w, height=artys7_h, lid_height=artys7_lid_h,
            xy_wall_width=artys7_wall_width, z_wall_width=artys7_bottom_wall_width,
            fitted_lid=fitted_lid, draw_lid=true,
            tolerance=ptr_tolerance
          );
          // IO socket
          //translate([2*artys7_wall_width, 1*artys7_wall_width-0.01, -2*artys7_bottom_wall_width])
          translate([artys7_l+0*artys7_wall_width-16, artys7_w-2*artys7_wall_width+0.01, -2*artys7_bottom_wall_width])
            cube([16, 3*artys7_wall_width+0.01, artys7_h+artys7_bottom_wall_width]);
        }
      }
}

difference() {
  *artys7_enclosure(draw_as_close_box=true);
  *artys7_enclosure(draw_lid=true, draw_container=true);
  artys7_enclosure(draw_container=true);
  *translate([artys7_enclosure_l/2, -10, -10])
    cube(500);
}
