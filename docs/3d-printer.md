# Monoprice Maker Select Plus

Note that these settings are specific to *my* Monoprice Maker Select Plus, [which has been somewhat heavily modified](https://www.finnie.org/2019/05/04/monoprice-maker-select-plus-3d-printer-mods/) (BLTouch, cross braces, 3-point glass bed, custom cooling, [custom Marlin](https://github.com/rfinnie/ADVi3pp-Marlin), etc). Feel free to use this information for ideas, but don't blindly copy it and expect it to work.

## Cura - Printer

### Printer Settings

* X (Width): 200 mm
* Y (Depth): 200 mm
* Z (Height): 174 mm (The carriage and Z end stop is raised 6 mm compared to normal to accomodate the glass build plate)
* Build plate shape: Rectangular
* Origin at center: [ ]
* Heated bed: [x]
* Heated build volume: [ ]
* G-code flavor: Marlin

### Printhead Settings

* X min: -35 mm
* Y min: -5 mm
* X max: 30 mm
* Y max: 50 mm
* Gantry Height: 174 mm
* Number of Extruders: 1
* Shared Heater: [ ]

### Start G-code

```gcode
G21 ;metric values
G90 ;absolute positioning
M82 ;set extruder to absolute mode
M107 ;start with the fan off
M117 Heating to {material_bed_temperature_layer_0}/{material_print_temperature_layer_0}...
M140 S{material_bed_temperature_layer_0}
M105
M190 S{material_bed_temperature_layer_0}
M104 S{material_print_temperature_layer_0}
M105
M109 S{material_print_temperature_layer_0}
M117 Going home...
G28 X0 Y0 ;move X/Y to min endstops
G28 Z0 ;move Z to min endstops
M420 S1 ; Retrieve previous auto-level data, or above
M420 Z10 ; fade leveling up to 10mm
G0 X0 Y0 F3000 ; Go to home (without homing: it would disable compensation)
G0 Z0 ; Go to min Z
; G0/G1 appears to block temp management while it's moving.
; Zeroing from the top can take long enough that the extruder drops 25C.
; We need to wait for the temps to settle again before extruding.
M117 Settling temp...
;M190 S{material_bed_temperature_layer_0} ;Bed doesn't drop that much
M109 S{material_print_temperature_layer_0}
M300 P500 ; Beep 0.5s
M117 Purging...
G92 E0 ;zero the extruded length
G1 E2 Z0.4 F200 ;extrude 2mm while going up 0.4mm, hopefully catching on the plate
G92 E0 ;zero the extruded length
G1 X60.0 E20 F500.0 ; start purge line, heavy flow
G92 E0 ;zero the extruded length
G1 X100.0 E4 F500.0 ; finish purge line
G92 E0 ;zero the extruded length
M117 Printing...
```

### Stop G-code

```gcode
M400 ;Finish Moves
M104 S0 ;extruder heater off
M140 S0 ;bed heater off
G91 ;relative positioning
G1 E-1 F300 ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+0.5 E-5 X-20 Y-20 F1200 ;move Z up a bit and retract filament even more
G0 Z+80 F300 ;Move Z up 80mm
M400 ;Finish Moves
G90 ;absolute positioning
G0 X10 Y175 F3600 ;Move plate to the front, and X just out of the endstop
M400 ;Finish Moves
M107 ;fan off
M84 ;steppers off
M18 ;Motors off
M300 P500 ; Beep 0.5s
M82 ;absolute extrusion mode
```

## Extruder 1

### Nozzle Settings

* Nozzle size: 0.4 mm
* Compatible material diameter: 1.75 mm
* Nozzle offset X: 0 mm
* Nozzle offset Y: 0 mm
* Cooling Fan Number: 0

### Extruder Start G-Code

```gcode
; Empty
```

### Extruder End G-Code

```gcode
; Empty
```

## Cura - "My" Profile

* Profile base: Draft
* Quality
    * Initial Layer Height: 0.2 mm (default 0.3 mm)
* Shell
    * Z Seam Alignment: Random (default Sharpest Corner)
* Infill
    * Infill Pattern: Cubic Subdivision (default Grid)
    * Infill Overlap Percentage: 30 % (default 10 %)
* Material
    * Initial Layer Flow: 125 % (default 100 %)
* Travel
    * Avoid Supports When Traveling: [x] (default [ ])
* Support
    * Support Overhang Angle: 70 ° (default 60 °)
* Build Plate Adhesion
    * Build Plate Adhesion Type: None (default Brim)
    * Raft Print Speed: 50 mm/s (default 30mm/s)
    * Skirt Line Count: 2 (default 1)

Fan speed remains 100% in GCODE, but a custom OctoPrint plugin reduces that by ½ during print, since the custom part cooler blower is too powerful.

## BLTouch

* Z offset target: -1.70 mm
* Adjustment screws: counter-clockwise closer to zero (+), clockwise farther from zero (-)
