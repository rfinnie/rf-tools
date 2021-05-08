# My 3D printers

Note that these settings are specific to *my* 3D printers, which have been heavily modified (BLTouch, cross braces, 3-point glass bed, custom cooling, custom Marlin, [etc](https://www.finnie.org/2019/05/04/monoprice-maker-select-plus-3d-printer-mods/)). Feel free to use this information for ideas, but don't blindly copy it and expect it to work.

## Creality Ender 3 V2

### Cura - Printer

#### Printer Settings

* X (Width): 220 mm
* Y (Depth): 220 mm
* Z (Height): 250 mm
* Build plate shape: Rectangular
* Origin at center: [ ]
* Heated bed: [x]
* Heated build volume: [ ]
* G-code flavor: Marlin

#### Printhead Settings

* X min: -26 mm
* Y min: -32 mm
* X max: 32 mm
* Y max: 34 mm
* Gantry Height: 25.0 mm
* Number of Extruders: 1
* Shared Heater: [ ]

#### Start G-code

```gcode
G92 E0 ; Reset Extruder
G28 ; Home all axes
@BEDLEVELVISUALIZER	; tell the plugin to watch for reported mesh
G29 ; Automatic bed leveling
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X0 Y0 Z0.4 F5000.0 ; Move to start position
G1 Z0.1 F200 ;go down to (almost) plate
G92 E0 ;zero the extruded length
G1 E2 Z0.4 F200 ;extrude 2mm while going up to 0.4mm, hopefully catching on the plate
G1 X48 E22 F500 ; start prime line 1, heavy flow
G1 X80 E26 F500 ; finish prime line 1
G1 Y0.4 F500 ; Move to line 2
G1 X40 E30 F500 ; Move backwards, slightly into heavy flow area
G92 E0 ;zero the extruded length
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
; layer 1
```

#### Stop G-code

```gcode
G91 ;Relative positioning
G1 E-2 F2700 ;Retract a bit
G1 E-2 Z0.2 F2400 ;Retract and raise Z
G1 X5 Y5 F3000 ;Wipe out
G1 Z80 ;Raise Z more
G90 ;Absolute positioning

G1 X0 Y{machine_depth} ;Present print
M106 S0 ;Turn-off fan
M104 S0 ;Turn-off hotend
M140 S0 ;Turn-off bed

M84 X Y E ;Disable all steppers but Z
```

### Extruder 1

#### Nozzle Settings

* Nozzle size: 0.4 mm
* Compatible material diameter: 1.75 mm
* Nozzle offset X: 0 mm
* Nozzle offset Y: 0 mm
* Cooling Fan Number: 0

#### Extruder Start G-Code

```gcode
; Empty
```

#### Extruder End G-Code

```gcode
; Empty
```

### Cura - "Ender 3 V2" Profile

Profile base: Draft

* Quality
    * Initial Layer Height: 0.2 mm (default 0.3 mm)
* Infill
    * Infill Pattern: Cubic Subdivision (default Grid)
    * Infill Overlap Percentage: 30 % (default 10 %)
* Material
    * Initial Layer Flow: 125 % (default 100 %)
* Speed
    * Print Speed: 120 mm/s (default 60 mm/s)
* Travel
    * Avoid Supports When Traveling: [x] (default [ ])
* Support
    * Support Overhang Angle: 70 ° (default 50 °)
* Build Plate Adhesion
    * Build Plate Adhesion Type: None (default Brim)
    * Raft Print Speed: 50 mm/s (default 30mm/s)
    * Skirt Line Count: 2 (default 1)
* Special Modes
    * Arc Welder: [x] (default [ ])

### Firmware

* [Marlin bugfix-2.0.x](https://github.com/rfinnie/Marlin)
* * There's a GitHub workflow which builds the firmware directly.
* [Marlin bugfix-2.0.x configurations](https://github.com/rfinnie/Marlin-Configurations)




## Monoprice Maker Select Plus

### Cura - Printer

#### Printer Settings

* X (Width): 200 mm
* Y (Depth): 200 mm
* Z (Height): 174 mm (6 mm lower than normal to accommodate the glass build plate)
* Build plate shape: Rectangular
* Origin at center: [ ]
* Heated bed: [x]
* Heated build volume: [ ]
* G-code flavor: Marlin

#### Printhead Settings

* X min: -35 mm
* Y min: -5 mm
* X max: 30 mm
* Y max: 50 mm
* Gantry Height: 174 mm
* Number of Extruders: 1
* Shared Heater: [ ]

#### Start G-code

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
G28 ; Go home
; G0/G1 appears to block temp management while it's moving.
; Zeroing from the top can take long enough that the extruder drops 25C.
; We need to wait for the temps to settle again before extruding.
M117 Settling temp...
;M190 S{material_bed_temperature_layer_0} ;Bed doesn't drop that much
M109 S{material_print_temperature_layer_0}
G29 ; Measure bed levels, or below
;M420 S1 ; Retrieve previous auto-level data, or above
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
G1 X0 Y0 Z0.4 F5000.0 ; Move to start position
G1 Z0.1 F200 ;go down to (almost) plate
G92 E0 ;zero the extruded length
G1 E2 Z0.4 F200 ;extrude 2mm while going up to 0.4mm, hopefully catching on the plate
G1 X48 E22 F500 ; start prime line 1, heavy flow
G1 X80 E26 F500 ; finish prime line 1
G1 Y0.4 F500 ; Move to line 2
G1 X40 E30 F500 ; Move backwards, slightly into heavy flow area
G92 E0 ;zero the extruded length
G1 Z2.0 F3000 ; Move Z Axis up little to prevent scratching of Heat Bed
M117 Printing...
; layer 1
```

#### Stop G-code

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
M82 ;absolute extrusion mode
```

### Extruder 1

#### Nozzle Settings

* Nozzle size: 0.4 mm
* Compatible material diameter: 1.75 mm
* Nozzle offset X: 0 mm
* Nozzle offset Y: 0 mm
* Cooling Fan Number: 0

#### Extruder Start G-Code

```gcode
; Empty
```

#### Extruder End G-Code

```gcode
; Empty
```

### Cura - "Maker Select Plus" Profile

Profile base: Draft

* Quality
    * Initial Layer Height: 0.2 mm (default 0.3 mm)
* Infill
    * Infill Pattern: Cubic Subdivision (default Grid)
    * Infill Overlap Percentage: 30 % (default 10 %)
* Material
    * Initial Layer Flow: 125 % (default 100 %)
* Travel
    * Avoid Supports When Traveling: [x] (default [ ])
* Support
    * Support Overhang Angle: 70 ° (default 50 °)
* Build Plate Adhesion
    * Build Plate Adhesion Type: None (default Brim)
    * Raft Print Speed: 50 mm/s (default 30mm/s)
    * Skirt Line Count: 2 (default 1)

Fan speed remains 100% in GCODE, but a custom OctoPrint plugin reduces that by ½ during print, since the custom part cooler blower is too powerful.

### Firmware

* [Fork of ADVi3++ 3.0.2 (Marlin 1.1.8) with BLTouch v3 support](https://github.com/rfinnie/ADVi3pp-Marlin)
* * There's a GitHub workflow which builds the firmware directly.
