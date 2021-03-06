set buttonlist { .mbar.materials .mbar.values .mbar.settings .mbar.reset }

proc disable_buttons {} {
# Disables all the buttons in the buttonlist
	global buttonlist
	foreach x $buttonlist {
		$x configure -state disabled
	}
}

proc enable_buttons {} {
# Enables all the buttons in the buttonlist
	global buttonlist
	foreach x $buttonlist {
		$x configure -state normal
	}
}


# ##############################################################
# Define the data structures & procedures for Concrete01
# ##############################################################

set MultiLinear(materialId) 1
set MultiLinear(e0) 0.05
set MultiLinear(s0) 10.0
set MultiLinear(e1) 0.15
set MultiLinear(s1) 20.0
set MultiLinear(e2) 0.30
set MultiLinear(s2) 30.0
set MultiLinear(e3) 0.60
set MultiLinear(s3) 40.0

#set MultiLinear(e3) 0.8
#set MultiLinear(s3) 40.0

$m add command -label MultiLinear -command "SetMultiLinear .multilinear"

proc SetMultiLinear {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId e0 s0 e1 s1 e2 s2 e3 s3} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable MultiLinear($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneMultiLinear; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set MultiLinear(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $MultiLinear(materialId)
    $w.ematerialId config -state disabled
}


proc doneMultiLinear { } {
    global matID
    global MultiLinear

    set matID $MultiLinear(materialId)
    uniaxialMaterial MultiLinear $matID $MultiLinear(e0) $MultiLinear(s0) $MultiLinear(e1) $MultiLinear(s1) $MultiLinear(e2) $MultiLinear(s2) $MultiLinear(e3) $MultiLinear(s3)

    eval uniaxialTest $matID
    set matID $MultiLinear(materialId)

    SetValues
    Reset
}

set Concrete01(materialId) 0
set Concrete01(fc) 0
set Concrete01(ec) 0
set Concrete01(fu) 0
set Concrete01(eu) 0

$m add command -label Concrete01 -command "SetConcrete01 .concrete01"

proc SetConcrete01 {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId fc ec fu eu} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Concrete01($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneConcrete01; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Concrete01(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Concrete01(materialId)
    $w.ematerialId config -state disabled
}


proc doneConcrete01 { } {
    global matID
    global Concrete01

    set matID $Concrete01(materialId)
    uniaxialMaterial Concrete01 $matID $Concrete01(fc) $Concrete01(ec) $Concrete01(fu) $Concrete01(eu)
    eval uniaxialTest $matID
    set matID $Concrete01(materialId)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for Concrete02
# ##############################################################

set Concrete02(materialId) 0
set Concrete02(fc) 0
set Concrete02(epsc0) 0
set Concrete02(fcu) 0
set Concrete02(epscu) 0
set Concrete02(rat) 0
set Concrete02(ft) 0
set Concrete02(Ets) 0

$m add command -label Concrete02 -command "SetConcrete02 .concrete02"

proc SetConcrete02 {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId fc epsc0 fcu epscu rat ft Ets} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Concrete02($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneConcrete02; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Concrete02(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Concrete02(materialId)
    $w.ematerialId config -state disabled
}


proc doneConcrete02 { } {
    global matID
    global Concrete02

    set matID $Concrete02(materialId)
    uniaxialMaterial Concrete02 $matID $Concrete02(fc) $Concrete02(epsc0) $Concrete02(fcu) $Concrete02(epscu) $Concrete02(rat) $Concrete02(ft) $Concrete02(Ets)
    eval uniaxialTest $matID
    set matID $Concrete02(materialId)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for Elastic
# ##############################################################

set Elastic(materialID) 0
set Elastic(E) 50

# add Elastic the materials menu
$m add command -label Elastic -command "SetElastic .elastic"

proc SetElastic {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialID E} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Elastic($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneElastic; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialID config -state normal
    set Elastic(materialID) [expr $matID + 1]
    $w.ematerialID delete 0 end
    $w.ematerialID insert 0 $Elastic(materialID)
    $w.ematerialID config -state disabled
}

proc doneElastic { } {
    global matID
    global Elastic

    set matID $Elastic(materialID)
    uniaxialMaterial Elastic $matID $Elastic(E)
    eval uniaxialTest $matID
    set matID $Elastic(materialID)

    SetValues
    Reset
}





# ##############################################################
# Define the data structures & procedures for ElasticPP
# ##############################################################

set ElasticPP(materialID) 0
set ElasticPP(E) 0
set ElasticPP(yieldStrain) 0    

# add ElasticPP the materials menu
$m add command -label ElasticPP -command "SetElasticPP .elasticPP"

proc SetElasticPP { w } {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialID E yieldStrain} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable ElasticPP($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneElasticPP; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialID config -state normal
    set ElasticPP(materialID) [expr $matID + 1]
    $w.ematerialID delete 0 end
    $w.ematerialID insert 0 $ElasticPP(materialID)
    $w.ematerialID config -state disabled

}

proc doneElasticPP { } {
    global matID
    global ElasticPP

    set matID $ElasticPP(materialID)
    uniaxialMaterial ElasticPP $matID $ElasticPP(E) $ElasticPP(yieldStrain)
    eval uniaxialTest $matID
    set matID $ElasticPP(materialID)

    SetValues
    Reset
}





# ##############################################################
# Define the data structures & procedures for ElasticPPGap
# ##############################################################

set elasticPPGap(materialID) 0
set elasticPPGap(E) 0
set elasticPPGap(fy) 0    
set elasticPPGap(gap) 0    

# add elasticPPGap the materials menu
$m add command -label ElasticPPGap -command "SetElasticPPGap .elasticPPGap"


proc SetElasticPPGap {w} {
    global matID

    disable_buttons;
    toplevel $w;

    set count 0
    foreach field {materialID E fy gap} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable elasticPPGap($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneElasticPPGap; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nse

    $w.ematerialID config -state normal
    set elasticPPGap(materialID) [expr $matID + 1]
    $w.ematerialID delete 0 end
    $w.ematerialID insert 0 $elasticPPGap(materialID)
    $w.ematerialID config -state disabled

}


proc doneElasticPPGap { } {
    global matID
    global elasticPPGap

    set matID $elasticPPGap(materialID)
    uniaxialMaterial ElasticPPGap $matID $elasticPPGap(E) $elasticPPGap(fy) $elasticPPGap(gap)
    eval uniaxialTest $matID
    set matID $elasticPPGap(materialID)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for ENT
# ##############################################################

set ENT(materialID) 0
set ENT(E) 0

# add ENT the materials menu
$m add command -label ENT -command "SetENT .ent"

proc SetENT {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialID E} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable ENT($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneENT; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialID config -state normal
    set ENT(materialID) [expr $matID + 1]
    $w.ematerialID delete 0 end
    $w.ematerialID insert 0 $ENT(materialID)
    $w.ematerialID config -state disabled
}

proc doneENT { } {
    global matID
    global ENT

    set matID $ENT(materialID)
    uniaxialMaterial ENT $matID $ENT(E)
    eval uniaxialTest $matID
    set matID $ENT(materialID)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for Hardening
# ##############################################################

set Hardening(materialId) 0
set Hardening(E) 0
set Hardening(sigY) 0
set Hardening(Hiso) 0
set Hardening(Hkin) 0

# add Hardening to the materials menu
$m add command -label Hardening -command "SetHardening .hardening"

proc SetHardening {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId E sigY Hiso Hkin} {
	label .hardening.l$field -text $field
	entry .hardening.e$field -textvariable Hardening($field) -relief sunken 
	grid .hardening.l$field -row $count -column 0 -sticky e
	grid .hardening.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button .hardening.ok -text OK -command "doneHardening; destroy $w; enable_buttons"
    grid .hardening.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    .hardening.ematerialId config -state normal
    set Hardening(materialId) [expr $matID + 1]
    .hardening.ematerialId delete 0 end
    .hardening.ematerialId insert 0 $Hardening(materialId)
    .hardening.ematerialId config -state disabled
}


proc doneHardening { } {
    global matID
    global Hardening

    set matID $Hardening(materialId)
    uniaxialMaterial Hardening $matID $Hardening(E) $Hardening(sigY) $Hardening(Hiso) $Hardening(Hkin)
    eval uniaxialTest $matID
    set matID $Hardening(materialId)

    SetValues
    Reset
}





# ##############################################################
# Define the data structures & procedures for Hysteretic
# ##############################################################

set Hysteretic(materialId) 0
set Hysteretic(s1p) 10.0
set Hysteretic(e1p) 0.1
set Hysteretic(s2p) 20.0
set Hysteretic(e2p) 0.3
set Hysteretic(s3p) 30.0
set Hysteretic(e3p) 0.7
set Hysteretic(s1n) -10.0
set Hysteretic(e1n) -0.1
set Hysteretic(s2n) -20.0
set Hysteretic(e2n) -0.2
set Hysteretic(s3n) -30.0
set Hysteretic(e3n) -0.7
set Hysteretic(px) 0
set Hysteretic(py) 0
set Hysteretic(d1) 0
set Hysteretic(d2) 0
set Hysteretic(beta) 0

# add Hysteretic to the materials menu
$m add command -label Hysteretic -command "SetHysteretic .hysteretic"

proc SetHysteretic {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId s1p e1p s2p e2p s3p e3p s1n e1n s2n e2n s3n e3n px py d1 d2 beta} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Hysteretic($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneHysteretic; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Hysteretic(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Hysteretic(materialId)
    $w.ematerialId config -state disabled
}


proc doneHysteretic { } {
    global matID
    global Hysteretic

    set matID $Hysteretic(materialId)
    uniaxialMaterial Hysteretic $matID $Hysteretic(s1p) $Hysteretic(e1p) $Hysteretic(s2p) $Hysteretic(e2p) $Hysteretic(s3p) $Hysteretic(e3p) $Hysteretic(s1n) $Hysteretic(e1n) $Hysteretic(s2n) $Hysteretic(e2n) $Hysteretic(s3n) $Hysteretic(e3n) $Hysteretic(px) $Hysteretic(py) $Hysteretic(d1) $Hysteretic(d2) $Hysteretic(beta)

    eval uniaxialTest $matID
    set matID $Hysteretic(materialId)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for Parallel
# ##############################################################

set Parallel(materialId) 0
set Parallel(matTag1) 0
set Parallel(matTag2) 0

# add Parallel to the materials menu
$m add command -label Parallel -command "SetParallel .parallel"

proc SetParallel {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId matTag1 matTag2} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Parallel($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneParallel; destroy $w; enable_buttons;"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Parallel(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Parallel(materialId)
    $w.ematerialId config -state disabled
}


proc doneParallel { } {
    global matID
    global Parallel

    set matID $Parallel(materialId)
    uniaxialMaterial Parallel $matID $Parallel(matTag1) $Parallel(matTag2)
    eval uniaxialTest $matID
    set matID $Parallel(materialId)

    SetValues
    Reset
}





# ##############################################################
# Define the data structures & procedures for PathIndependent
# ##############################################################

set PathInd(materialId) 0
set PathInd(otherMatId) 0

# add PathIndependent to the materials menu
$m add command -label PathIndependent -command "SetPathInd .pathInd"

proc SetPathInd {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId otherMatId} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable PathInd($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "donePathInd; destroy $w; enable_buttons;"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set PathInd(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $PathInd(materialId)
    $w.ematerialId config -state disabled
}


proc donePathInd { } {
    global matID
    global PathInd

    set matID $PathInd(materialId)
    uniaxialMaterial PathIndependent $matID $PathInd(otherMatId)
    eval uniaxialTest $matID
    set matID $PathInd(materialId)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for Series
# ##############################################################

set Series(materialId) 0
set Series(matTag1) 0
set Series(matTag2) 0

# add Series to the materials menu
$m add command -label Series -command "SetSeries .series"

proc SetSeries {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId matTag1 matTag2} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Series($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneSeries; destroy $w; enable_buttons;"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Series(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Series(materialId)
    $w.ematerialId config -state disabled
}


proc doneSeries { } {
    global matID
    global Series

    set matID $Series(materialId)
    uniaxialMaterial Series $matID $Series(matTag1) $Series(matTag2)
    eval uniaxialTest $matID
    set matID $Series(materialId)

    SetValues
    Reset
}



# ##############################################################
# Define the data structures & procedures for Steel01
# ##############################################################

set Steel01(materialId) 0
set Steel01(fy) 0
set Steel01(E) 0
set Steel01(b) 0
set Steel01(a1) 0
set Steel01(a2) 55
set Steel01(a3) 0
set Steel01(a4) 55


# add Steel01 to the materials menu
$m add command -label Steel01 -command "SetSteel01 .steel01"

proc SetSteel01 {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId fy E b a1 a2 a3 a4} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Steel01($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneSteel01; destroy $w; enable_buttons;"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Steel01(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Steel01(materialId)
    $w.ematerialId config -state disabled
}


proc doneSteel01 { } {
    global matID
    global Steel01

    set matID $Steel01(materialId)
    uniaxialMaterial Steel01 $matID $Steel01(fy) $Steel01(E) $Steel01(b) $Steel01(a1) $Steel01(a2) $Steel01(a3) $Steel01(a4)
    eval uniaxialTest $matID
    set matID $Steel01(materialId)

    SetValues
    Reset
}




# add Steel02 to the materials menu
$m add command -label Steel02 -command "SetSteel02 .steel02"

proc SetSteel02 {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId fy E b R0 cR1 cR2 a1 a2 a3 a4} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable Steel02($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneSteel02; destroy $w; enable_buttons;"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set Steel02(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $Steel02(materialId)
    $w.ematerialId config -state disabled
}


proc doneSteel02 { } {
    global matID
    global Steel02

    set matID $Steel02(materialId)
    uniaxialMaterial Steel02 $matID $Steel02(fy) $Steel02(E) $Steel02(b) $Steel02(R0) $Steel02(cR1) $Steel02(cR2) $Steel02(a1) $Steel02(a2) $Steel02(a3) $Steel02(a4)
    eval uniaxialTest $matID
    set matID $Steel02(materialId)

    SetValues
    Reset
}




# ##############################################################
# Define the data structures & procedures for KinematicHardening
# ##############################################################

set KinematicHardening(materialId) 0
set KinematicHardening(E) 0
set KinematicHardening(Ekh) 0
set KinematicHardening(sigY) 0

# add KinematicHardening to the materials menu

#$m add command -label KinematicHardening -command "SetKinematicHardening .hardening"

proc SetKinematicHardening {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId E Ekh sigY} {
	label .hardening.l$field -text $field
	entry .hardening.e$field -textvariable KinematicHardening($field) -relief sunken 
	grid .hardening.l$field -row $count -column 0 -sticky e
	grid .hardening.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button .hardening.ok -text OK -command "doneKinematicHardening; destroy $w; enable_buttons"
    grid .hardening.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    .hardening.ematerialId config -state normal
    set KinematicHardening(materialId) [expr $matID + 1]
    .hardening.ematerialId delete 0 end
    .hardening.ematerialId insert 0 $KinematicHardening(materialId)
    .hardening.ematerialId config -state disabled
}


proc doneKinematicHardening { } {
    global matID
    global KinematicHardening

    set matID $KinematicHardening(materialId)
    uniaxialMaterial KinematicHardening $matID $KinematicHardening(E) $KinematicHardening(Ekh) $KinematicHardening(sigY) 
    eval uniaxialTest $matID
    set matID $KinematicHardening(materialId)

    SetValues
    Reset
}


set HookGap(materialId) 1
set HookGap(E) 70.0
set HookGap(eN) -0.1
set HookGap(eP) 0.3

$m add command -label HookGap -command "SetHookGap .multilinear"

proc SetHookGap {w} {
    global matID

    # Turn off all buttons & create a top level window
    disable_buttons
    toplevel $w

    set count 0
    foreach field {materialId E eN eP} {
	label $w.l$field -text $field
	entry $w.e$field -textvariable HookGap($field) -relief sunken 
	grid $w.l$field -row $count -column 0 -sticky e
	grid $w.e$field -row $count -column 1 -sticky ew
	incr count
    }

    button $w.ok -text OK -command "doneHookGap; destroy $w; enable_buttons"
    grid $w.ok -row 0 -rowspan 3 -column 2 -sticky nsew

    $w.ematerialId config -state normal
    set HookGap(materialId) [expr $matID + 1]
    $w.ematerialId delete 0 end
    $w.ematerialId insert 0 $HookGap(materialId)
    $w.ematerialId config -state disabled
}


proc doneHookGap { } {
    global matID
    global HookGap

    set matID $HookGap(materialId)
    uniaxialMaterial HookGap $matID $HookGap(E) $HookGap(eN) $HookGap(eP)

    eval uniaxialTest $matID
    set matID $HookGap(materialId)

    SetValues
    Reset
}
