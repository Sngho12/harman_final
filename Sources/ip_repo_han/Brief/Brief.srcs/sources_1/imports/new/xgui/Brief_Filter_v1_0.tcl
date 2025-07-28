# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "IMAGE_BITS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IMAGE_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IMAGE_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PATTERN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.IMAGE_BITS { PARAM_VALUE.IMAGE_BITS } {
	# Procedure called to update IMAGE_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IMAGE_BITS { PARAM_VALUE.IMAGE_BITS } {
	# Procedure called to validate IMAGE_BITS
	return true
}

proc update_PARAM_VALUE.IMAGE_LENGTH { PARAM_VALUE.IMAGE_LENGTH } {
	# Procedure called to update IMAGE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IMAGE_LENGTH { PARAM_VALUE.IMAGE_LENGTH } {
	# Procedure called to validate IMAGE_LENGTH
	return true
}

proc update_PARAM_VALUE.IMAGE_WIDTH { PARAM_VALUE.IMAGE_WIDTH } {
	# Procedure called to update IMAGE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IMAGE_WIDTH { PARAM_VALUE.IMAGE_WIDTH } {
	# Procedure called to validate IMAGE_WIDTH
	return true
}

proc update_PARAM_VALUE.PATTERN { PARAM_VALUE.PATTERN } {
	# Procedure called to update PATTERN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PATTERN { PARAM_VALUE.PATTERN } {
	# Procedure called to validate PATTERN
	return true
}

proc update_PARAM_VALUE.X_WIDTH { PARAM_VALUE.X_WIDTH } {
	# Procedure called to update X_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.X_WIDTH { PARAM_VALUE.X_WIDTH } {
	# Procedure called to validate X_WIDTH
	return true
}

proc update_PARAM_VALUE.Y_WIDTH { PARAM_VALUE.Y_WIDTH } {
	# Procedure called to update Y_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Y_WIDTH { PARAM_VALUE.Y_WIDTH } {
	# Procedure called to validate Y_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.IMAGE_WIDTH { MODELPARAM_VALUE.IMAGE_WIDTH PARAM_VALUE.IMAGE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IMAGE_WIDTH}] ${MODELPARAM_VALUE.IMAGE_WIDTH}
}

proc update_MODELPARAM_VALUE.IMAGE_LENGTH { MODELPARAM_VALUE.IMAGE_LENGTH PARAM_VALUE.IMAGE_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IMAGE_LENGTH}] ${MODELPARAM_VALUE.IMAGE_LENGTH}
}

proc update_MODELPARAM_VALUE.IMAGE_BITS { MODELPARAM_VALUE.IMAGE_BITS PARAM_VALUE.IMAGE_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IMAGE_BITS}] ${MODELPARAM_VALUE.IMAGE_BITS}
}

proc update_MODELPARAM_VALUE.PATTERN { MODELPARAM_VALUE.PATTERN PARAM_VALUE.PATTERN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PATTERN}] ${MODELPARAM_VALUE.PATTERN}
}

proc update_MODELPARAM_VALUE.X_WIDTH { MODELPARAM_VALUE.X_WIDTH PARAM_VALUE.X_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_WIDTH}] ${MODELPARAM_VALUE.X_WIDTH}
}

proc update_MODELPARAM_VALUE.Y_WIDTH { MODELPARAM_VALUE.Y_WIDTH PARAM_VALUE.Y_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_WIDTH}] ${MODELPARAM_VALUE.Y_WIDTH}
}

