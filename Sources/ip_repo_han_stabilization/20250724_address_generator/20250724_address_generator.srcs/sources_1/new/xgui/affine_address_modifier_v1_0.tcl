# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set FRAME&DATA_SIZE [ipgui::add_group $IPINST -name "FRAME&DATA SIZE" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "LINE_LENGHT" -parent ${FRAME&DATA_SIZE}
  ipgui::add_param $IPINST -name "FRAME_HEIGHT" -parent ${FRAME&DATA_SIZE}
  ipgui::add_param $IPINST -name "ADDRESS_SIZE_X" -parent ${FRAME&DATA_SIZE}
  ipgui::add_param $IPINST -name "ADDRESS_SIZE_Y" -parent ${FRAME&DATA_SIZE}

  #Adding Group
  set ACCUMUL_AFFINE_THRES [ipgui::add_group $IPINST -name "ACCUMUL AFFINE THRES" -parent ${Page_0}]
  ipgui::add_static_text $IPINST -name "accumul affine thres description" -parent ${ACCUMUL_AFFINE_THRES} -text {default affine =[ [1024,0,0] , [0,1024,0] ]

rotate thres defines maximum rotation coefficient

XY thres defines maximum pixel translation}
  ipgui::add_param $IPINST -name "ACCUMUL_AFFINE_ROTATE_THRES" -parent ${ACCUMUL_AFFINE_THRES}
  ipgui::add_param $IPINST -name "ACCUMUL_AFFINE_Y_THRES" -parent ${ACCUMUL_AFFINE_THRES}
  ipgui::add_param $IPINST -name "ACCUMUL_AFFINE_X_THRES" -parent ${ACCUMUL_AFFINE_THRES}

  #Adding Group
  set RESILIENCE [ipgui::add_group $IPINST -name "RESILIENCE" -parent ${Page_0}]
  ipgui::add_static_text $IPINST -name "RESILIENCE description" -parent ${RESILIENCE} -text {the force that restores the screen to its original state
default: 3/1/1}
  ipgui::add_param $IPINST -name "ROTATION_RESILIENCE" -parent ${RESILIENCE}
  ipgui::add_param $IPINST -name "TRANSLATION_X_RESILIENCE" -parent ${RESILIENCE}
  ipgui::add_param $IPINST -name "TRANSLATION_Y_RESILIENCE" -parent ${RESILIENCE}



}

proc update_PARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES { PARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES } {
	# Procedure called to update ACCUMUL_AFFINE_ROTATE_THRES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES { PARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES } {
	# Procedure called to validate ACCUMUL_AFFINE_ROTATE_THRES
	return true
}

proc update_PARAM_VALUE.ACCUMUL_AFFINE_X_THRES { PARAM_VALUE.ACCUMUL_AFFINE_X_THRES } {
	# Procedure called to update ACCUMUL_AFFINE_X_THRES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACCUMUL_AFFINE_X_THRES { PARAM_VALUE.ACCUMUL_AFFINE_X_THRES } {
	# Procedure called to validate ACCUMUL_AFFINE_X_THRES
	return true
}

proc update_PARAM_VALUE.ACCUMUL_AFFINE_Y_THRES { PARAM_VALUE.ACCUMUL_AFFINE_Y_THRES } {
	# Procedure called to update ACCUMUL_AFFINE_Y_THRES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACCUMUL_AFFINE_Y_THRES { PARAM_VALUE.ACCUMUL_AFFINE_Y_THRES } {
	# Procedure called to validate ACCUMUL_AFFINE_Y_THRES
	return true
}

proc update_PARAM_VALUE.ADDRESS_SIZE_X { PARAM_VALUE.ADDRESS_SIZE_X } {
	# Procedure called to update ADDRESS_SIZE_X when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESS_SIZE_X { PARAM_VALUE.ADDRESS_SIZE_X } {
	# Procedure called to validate ADDRESS_SIZE_X
	return true
}

proc update_PARAM_VALUE.ADDRESS_SIZE_Y { PARAM_VALUE.ADDRESS_SIZE_Y } {
	# Procedure called to update ADDRESS_SIZE_Y when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDRESS_SIZE_Y { PARAM_VALUE.ADDRESS_SIZE_Y } {
	# Procedure called to validate ADDRESS_SIZE_Y
	return true
}

proc update_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to update FRAME_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to validate FRAME_HEIGHT
	return true
}

proc update_PARAM_VALUE.LINE_LENGHT { PARAM_VALUE.LINE_LENGHT } {
	# Procedure called to update LINE_LENGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINE_LENGHT { PARAM_VALUE.LINE_LENGHT } {
	# Procedure called to validate LINE_LENGHT
	return true
}

proc update_PARAM_VALUE.ROTATION_RESILIENCE { PARAM_VALUE.ROTATION_RESILIENCE } {
	# Procedure called to update ROTATION_RESILIENCE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROTATION_RESILIENCE { PARAM_VALUE.ROTATION_RESILIENCE } {
	# Procedure called to validate ROTATION_RESILIENCE
	return true
}

proc update_PARAM_VALUE.TRANSLATION_X_RESILIENCE { PARAM_VALUE.TRANSLATION_X_RESILIENCE } {
	# Procedure called to update TRANSLATION_X_RESILIENCE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRANSLATION_X_RESILIENCE { PARAM_VALUE.TRANSLATION_X_RESILIENCE } {
	# Procedure called to validate TRANSLATION_X_RESILIENCE
	return true
}

proc update_PARAM_VALUE.TRANSLATION_Y_RESILIENCE { PARAM_VALUE.TRANSLATION_Y_RESILIENCE } {
	# Procedure called to update TRANSLATION_Y_RESILIENCE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TRANSLATION_Y_RESILIENCE { PARAM_VALUE.TRANSLATION_Y_RESILIENCE } {
	# Procedure called to validate TRANSLATION_Y_RESILIENCE
	return true
}


proc update_MODELPARAM_VALUE.LINE_LENGHT { MODELPARAM_VALUE.LINE_LENGHT PARAM_VALUE.LINE_LENGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINE_LENGHT}] ${MODELPARAM_VALUE.LINE_LENGHT}
}

proc update_MODELPARAM_VALUE.FRAME_HEIGHT { MODELPARAM_VALUE.FRAME_HEIGHT PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_HEIGHT}] ${MODELPARAM_VALUE.FRAME_HEIGHT}
}

proc update_MODELPARAM_VALUE.ADDRESS_SIZE_X { MODELPARAM_VALUE.ADDRESS_SIZE_X PARAM_VALUE.ADDRESS_SIZE_X } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESS_SIZE_X}] ${MODELPARAM_VALUE.ADDRESS_SIZE_X}
}

proc update_MODELPARAM_VALUE.ADDRESS_SIZE_Y { MODELPARAM_VALUE.ADDRESS_SIZE_Y PARAM_VALUE.ADDRESS_SIZE_Y } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDRESS_SIZE_Y}] ${MODELPARAM_VALUE.ADDRESS_SIZE_Y}
}

proc update_MODELPARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES { MODELPARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES PARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES}] ${MODELPARAM_VALUE.ACCUMUL_AFFINE_ROTATE_THRES}
}

proc update_MODELPARAM_VALUE.ACCUMUL_AFFINE_X_THRES { MODELPARAM_VALUE.ACCUMUL_AFFINE_X_THRES PARAM_VALUE.ACCUMUL_AFFINE_X_THRES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACCUMUL_AFFINE_X_THRES}] ${MODELPARAM_VALUE.ACCUMUL_AFFINE_X_THRES}
}

proc update_MODELPARAM_VALUE.ACCUMUL_AFFINE_Y_THRES { MODELPARAM_VALUE.ACCUMUL_AFFINE_Y_THRES PARAM_VALUE.ACCUMUL_AFFINE_Y_THRES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACCUMUL_AFFINE_Y_THRES}] ${MODELPARAM_VALUE.ACCUMUL_AFFINE_Y_THRES}
}

proc update_MODELPARAM_VALUE.ROTATION_RESILIENCE { MODELPARAM_VALUE.ROTATION_RESILIENCE PARAM_VALUE.ROTATION_RESILIENCE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROTATION_RESILIENCE}] ${MODELPARAM_VALUE.ROTATION_RESILIENCE}
}

proc update_MODELPARAM_VALUE.TRANSLATION_X_RESILIENCE { MODELPARAM_VALUE.TRANSLATION_X_RESILIENCE PARAM_VALUE.TRANSLATION_X_RESILIENCE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRANSLATION_X_RESILIENCE}] ${MODELPARAM_VALUE.TRANSLATION_X_RESILIENCE}
}

proc update_MODELPARAM_VALUE.TRANSLATION_Y_RESILIENCE { MODELPARAM_VALUE.TRANSLATION_Y_RESILIENCE PARAM_VALUE.TRANSLATION_Y_RESILIENCE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TRANSLATION_Y_RESILIENCE}] ${MODELPARAM_VALUE.TRANSLATION_Y_RESILIENCE}
}

