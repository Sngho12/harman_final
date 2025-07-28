# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "HORIZEN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MATCH_LIMIT_X" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MATCH_LIMIT_Y" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_WEIGHT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PATTERN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RAM_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "VERTICAL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "X_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Y_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.HORIZEN { PARAM_VALUE.HORIZEN } {
	# Procedure called to update HORIZEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HORIZEN { PARAM_VALUE.HORIZEN } {
	# Procedure called to validate HORIZEN
	return true
}

proc update_PARAM_VALUE.MATCH_LIMIT_X { PARAM_VALUE.MATCH_LIMIT_X } {
	# Procedure called to update MATCH_LIMIT_X when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MATCH_LIMIT_X { PARAM_VALUE.MATCH_LIMIT_X } {
	# Procedure called to validate MATCH_LIMIT_X
	return true
}

proc update_PARAM_VALUE.MATCH_LIMIT_Y { PARAM_VALUE.MATCH_LIMIT_Y } {
	# Procedure called to update MATCH_LIMIT_Y when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MATCH_LIMIT_Y { PARAM_VALUE.MATCH_LIMIT_Y } {
	# Procedure called to validate MATCH_LIMIT_Y
	return true
}

proc update_PARAM_VALUE.MAX_WEIGHT { PARAM_VALUE.MAX_WEIGHT } {
	# Procedure called to update MAX_WEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_WEIGHT { PARAM_VALUE.MAX_WEIGHT } {
	# Procedure called to validate MAX_WEIGHT
	return true
}

proc update_PARAM_VALUE.PATTERN { PARAM_VALUE.PATTERN } {
	# Procedure called to update PATTERN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PATTERN { PARAM_VALUE.PATTERN } {
	# Procedure called to validate PATTERN
	return true
}

proc update_PARAM_VALUE.RAM_SIZE { PARAM_VALUE.RAM_SIZE } {
	# Procedure called to update RAM_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAM_SIZE { PARAM_VALUE.RAM_SIZE } {
	# Procedure called to validate RAM_SIZE
	return true
}

proc update_PARAM_VALUE.VERTICAL { PARAM_VALUE.VERTICAL } {
	# Procedure called to update VERTICAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VERTICAL { PARAM_VALUE.VERTICAL } {
	# Procedure called to validate VERTICAL
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


proc update_MODELPARAM_VALUE.PATTERN { MODELPARAM_VALUE.PATTERN PARAM_VALUE.PATTERN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PATTERN}] ${MODELPARAM_VALUE.PATTERN}
}

proc update_MODELPARAM_VALUE.RAM_SIZE { MODELPARAM_VALUE.RAM_SIZE PARAM_VALUE.RAM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAM_SIZE}] ${MODELPARAM_VALUE.RAM_SIZE}
}

proc update_MODELPARAM_VALUE.VERTICAL { MODELPARAM_VALUE.VERTICAL PARAM_VALUE.VERTICAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VERTICAL}] ${MODELPARAM_VALUE.VERTICAL}
}

proc update_MODELPARAM_VALUE.HORIZEN { MODELPARAM_VALUE.HORIZEN PARAM_VALUE.HORIZEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HORIZEN}] ${MODELPARAM_VALUE.HORIZEN}
}

proc update_MODELPARAM_VALUE.MATCH_LIMIT_X { MODELPARAM_VALUE.MATCH_LIMIT_X PARAM_VALUE.MATCH_LIMIT_X } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MATCH_LIMIT_X}] ${MODELPARAM_VALUE.MATCH_LIMIT_X}
}

proc update_MODELPARAM_VALUE.MATCH_LIMIT_Y { MODELPARAM_VALUE.MATCH_LIMIT_Y PARAM_VALUE.MATCH_LIMIT_Y } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MATCH_LIMIT_Y}] ${MODELPARAM_VALUE.MATCH_LIMIT_Y}
}

proc update_MODELPARAM_VALUE.MAX_WEIGHT { MODELPARAM_VALUE.MAX_WEIGHT PARAM_VALUE.MAX_WEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_WEIGHT}] ${MODELPARAM_VALUE.MAX_WEIGHT}
}

proc update_MODELPARAM_VALUE.X_WIDTH { MODELPARAM_VALUE.X_WIDTH PARAM_VALUE.X_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_WIDTH}] ${MODELPARAM_VALUE.X_WIDTH}
}

proc update_MODELPARAM_VALUE.Y_WIDTH { MODELPARAM_VALUE.Y_WIDTH PARAM_VALUE.Y_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_WIDTH}] ${MODELPARAM_VALUE.Y_WIDTH}
}

