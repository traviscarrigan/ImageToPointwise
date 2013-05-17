# ==================================================================================================
# IMPORT IMAGES INTO POINTWISE
# ==================================================================================================
# Written by Travis Carrigan
# 
# v1: Oct. 01, 2012
#
# Example Conversion
# -------------------
# pngtopnm -plain sample.png > sample.rgb
#

# Load Glyph
package require PWI_Glyph

# Setup Pointwise and define working directory
pw::Application reset
pw::Application clearModified
set scriptDir [file dirname [info script]]

set fileName "$scriptDir/rgb/sample.rgb"
set type "points"; # points or cells

set fl [open [file join $scriptDir $fileName]]
set rgbDataFile [read $fl]
close $fl
set rgbDataLines [split $rgbDataFile \n]
set rgbData [join $rgbDataLines]
unset rgbDataLines
set imageWidth [lindex $rgbData 1]
set imageHeight [lindex $rgbData 2]
set rgbData [lrange $rgbData 4 end]
pw::DatabaseEntity setDefault FillMode Flat

proc CreatePoint {origin width height color} {

    set bl(x) [lindex $origin 0]
    set bl(y) [lindex $origin 1]
    set bl(z) [lindex $origin 2]

    set pt(x) [expr {$bl(x) + 0.5 * $width}]
    set pt(y) [expr {$bl(y) + 0.5 * $height}]
    set pt(z) $bl(z)

    set r [lindex $color 0]
    set g [lindex $color 1]
    set b [lindex $color 2]

    set pwr [expr {$r/255.0}]
    set pwg [expr {$g/255.0}]
    set pwb [expr {$b/255.0}]
        
    set point [pw::Point create]
        $point setPoint "$pt(x) $pt(y) $pt(z)"
        $point setRenderAttribute ColorMode Entity
        $point setRenderAttribute LineMode None
        $point setColor [list $pwr $pwg $pwb]

}

proc CreateCell {origin width height color} {

    set bl(x) [lindex $origin 0]
    set bl(y) [lindex $origin 1]
    set bl(z) [lindex $origin 2]

    set br(x) [expr {$bl(x) + $width}]
    set br(y) $bl(y)
    set br(z) $bl(z)

    set tr(x) $br(x)
    set tr(y) [expr {$br(y) + $height}]
    set tr(z) $bl(z)
    
    set tl(x) $bl(x)
    set tl(y) $tr(y)
    set tl(z) $bl(z)

    set r [lindex $color 0]
    set g [lindex $color 1]
    set b [lindex $color 2]

    set pwr [expr {$r/255.0}]
    set pwg [expr {$g/255.0}]
    set pwb [expr {$b/255.0}]
        
    set seg(b) [pw::SegmentSpline create]
        $seg(b) addPoint "$bl(x) $bl(y) $bl(z)"
        $seg(b) addPoint "$br(x) $br(y) $br(z)"

    set seg(r) [pw::SegmentSpline create]
        $seg(r) addPoint "$br(x) $br(y) $br(z)"
        $seg(r) addPoint "$tr(x) $tr(y) $tr(z)"

    set seg(t) [pw::SegmentSpline create]
        $seg(t) addPoint "$tr(x) $tr(y) $tr(z)"
        $seg(t) addPoint "$tl(x) $tl(y) $tl(z)"

    set seg(l) [pw::SegmentSpline create]
        $seg(l) addPoint "$tl(x) $tl(y) $tl(z)"
        $seg(l) addPoint "$bl(x) $bl(y) $bl(z)"

    set crv(b) [pw::Curve create]
        $crv(b) addSegment $seg(b)

    set crv(l) [pw::Curve create]
        $crv(l) addSegment $seg(l)

    set crv(t) [pw::Curve create]
        $crv(t) addSegment $seg(t)

    set crv(r) [pw::Curve create]
        $crv(r) addSegment $seg(r)

    set cell [pw::Surface createFromCurves [list $crv(b) $crv(l) $crv(t) $crv(r)]]
        $cell setRenderAttribute ColorMode Entity
        $cell setRenderAttribute LineMode None
        $cell setColor [list $pwr $pwg $pwb]

    $crv(b) delete
    $crv(l) delete
    $crv(t) delete
    $crv(r) delete

}

if {$type == "points"} {
    set k 0
    for {set j [expr {$imageHeight - 1}]} {$j >= 0} {incr j -1} {

        for {set i 0} {$i < $imageWidth} {incr i} {

            CreatePoint "$i $j 0" 1.0 1.0 [lrange $rgbData [expr {3 * $k}] [expr {(3 * $k) + 2}]]
            incr k

        }

    }
} 

if {$type == "cells"} {
    set k 0
    for {set j [expr {$imageHeight - 1}]} {$j >= 0} {incr j -1} {

        for {set i 0} {$i < $imageWidth} {incr i} {

            CreateCell "$i $j 0" 1.0 1.0 [lrange $rgbData [expr {3 * $k}] [expr {(3 * $k) + 2}]]
            incr k

        }

    }
} 
