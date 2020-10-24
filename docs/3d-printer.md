# Monoprice Maker Select Plus - Cura settings

Note that these settings are specific to *my* Monoprice Maker Select Plus, which has been somewhat heavily modified (BLTouch, cross braces, 3-point glass bed, custom cooling, custom Marlin, etc). Feel free to use this information for ideas, but don't blindly copy it and expect it to work.

## Printer

### Printer Settings

* X (Width): 200 mm
* Y (Depth): 200 mm
* Z (Height): 174 mm
* Build plate shape: Rectangular
* Origin at center: [ ]
* Heated bed: [x]
* Heated build volume: [x]
* G-code flavor: Marlin

### Printhead Settings

* X min: -20 mm
* Y min: -10 mm
* X max: 10 mm
* Y max: 10 mm
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
G1 X0 Y0 F3000 ; Go to home (without homing: it would disable compensation)
G1 Z0 ; Go to min Z
; G1 appears to block temp management while it's moving.
; Zeroing from the top can take long enough that the extruder drops 25C.
; We need to wait for the temps to settle again before extruding.
M117 Settling temp...
M190 S{material_bed_temperature_layer_0}
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
G91 ;relative positioning
G1 E-1 F300 ;retract the filament a bit before lifting the nozzle, to release some of the pressure
G1 Z+0.5 E-5 X-20 Y-20 F1200 ;move Z up a bit and retract filament even more
G0 Z+80 F300 ;Move Z up 80mm
M400 ;Finish Moves
G90 ;absolute positioning
G0 X10 Y175 F3600 ;Move plate to the front, and X just out of the endstop
M400 ;Finish Moves
M84 ;steppers off
M18 ;Motors off
M300 P500 ; Beep 0.5s
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
```

### Extruder End G-Code

```gcode
```
