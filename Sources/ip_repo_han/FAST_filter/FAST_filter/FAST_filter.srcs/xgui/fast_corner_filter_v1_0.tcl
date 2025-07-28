# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set Frame_Size [ipgui::add_group $IPINST -name "Frame Size" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "LINE_LENGTH" -parent ${Frame_Size}
  ipgui::add_param $IPINST -name "FRAME_HEIGHT" -parent ${Frame_Size}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Frame_Size}

  #Adding Group
  set Detect_Conditions [ipgui::add_group $IPINST -name "Detect Conditions" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "THRES_CONTRAST" -parent ${Detect_Conditions}
  ipgui::add_param $IPINST -name "CONSECUTIVE_P" -parent ${Detect_Conditions}
  ipgui::add_param $IPINST -name "CONSECUTIVE_N" -parent ${Detect_Conditions}

  #Adding Group
  set Detect_Margin [ipgui::add_group $IPINST -name "Detect Margin" -parent ${Page_0}]
  ipgui::add_static_text $IPINST -name "Margin description" -parent ${Detect_Margin} -text {"is_corner" is always 0 within margin}
  ipgui::add_param $IPINST -name "EDGE_MARGIN_X" -parent ${Detect_Margin}
  ipgui::add_param $IPINST -name "EDGE_MARGIN_Y" -parent ${Detect_Margin}



}

proc update_PARAM_VALUE.CONSECUTIVE_N { PARAM_VALUE.CONSECUTIVE_N } {
	# Procedure called to update CONSECUTIVE_N when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONSECUTIVE_N { PARAM_VALUE.CONSECUTIVE_N } {
	# Procedure called to validate CONSECUTIVE_N
	return true
}

proc update_PARAM_VALUE.CONSECUTIVE_P { PARAM_VALUE.CONSECUTIVE_P } {
	# Procedure called to update CONSECUTIVE_P when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONSECUTIVE_P { PARAM_VALUE.CONSECUTIVE_P } {
	# Procedure called to validate CONSECUTIVE_P
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.EDGE_MARGIN_X { PARAM_VALUE.EDGE_MARGIN_X } {
	# Procedure called to update EDGE_MARGIN_X when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EDGE_MARGIN_X { PARAM_VALUE.EDGE_MARGIN_X } {
	# Procedure called to validate EDGE_MARGIN_X
	return true
}

proc update_PARAM_VALUE.EDGE_MARGIN_Y { PARAM_VALUE.EDGE_MARGIN_Y } {
	# Procedure called to update EDGE_MARGIN_Y when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EDGE_MARGIN_Y { PARAM_VALUE.EDGE_MARGIN_Y } {
	# Procedure called to validate EDGE_MARGIN_Y
	return true
}

proc update_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to update FRAME_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to validate FRAME_HEIGHT
	return true
}

proc update_PARAM_VALUE.LINE_LENGTH { PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to update LINE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINE_LENGTH { PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to validate LINE_LENGTH
	return true
}

proc update_PARAM_VALUE.THRES_CONTRAST { PARAM_VALUE.THRES_CONTRAST } {
	# Procedure called to update THRES_CONTRAST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.THRES_CONTRAST { PARAM_VALUE.THRES_CONTRAST } {
	# Procedure called to validate THRES_CONTRAST
	return true
}


proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.THRES_CONTRAST { MODELPARAM_VALUE.THRES_CONTRAST PARAM_VALUE.THRES_CONTRAST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.THRES_CONTRAST}] ${MODELPARAM_VALUE.THRES_CONTRAST}
}

proc update_MODELPARAM_VALUE.FRAME_HEIGHT { MODELPARAM_VALUE.FRAME_HEIGHT PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_HEIGHT}] ${MODELPARAM_VALUE.FRAME_HEIGHT}
}

proc update_MODELPARAM_VALUE.LINE_LENGTH { MODELPARAM_VALUE.LINE_LENGTH PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINE_LENGTH}] ${MODELPARAM_VALUE.LINE_LENGTH}
}

proc update_MODELPARAM_VALUE.EDGE_MARGIN_X { MODELPARAM_VALUE.EDGE_MARGIN_X PARAM_VALUE.EDGE_MARGIN_X } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EDGE_MARGIN_X}] ${MODELPARAM_VALUE.EDGE_MARGIN_X}
}

proc update_MODELPARAM_VALUE.EDGE_MARGIN_Y { MODELPARAM_VALUE.EDGE_MARGIN_Y PARAM_VALUE.EDGE_MARGIN_Y } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EDGE_MARGIN_Y}] ${MODELPARAM_VALUE.EDGE_MARGIN_Y}
}

proc update_MODELPARAM_VALUE.CONSECUTIVE_P { MODELPARAM_VALUE.CONSECUTIVE_P PARAM_VALUE.CONSECUTIVE_P } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONSECUTIVE_P}] ${MODELPARAM_VALUE.CONSECUTIVE_P}
}

proc update_MODELPARAM_VALUE.CONSECUTIVE_N { MODELPARAM_VALUE.CONSECUTIVE_N PARAM_VALUE.CONSECUTIVE_N } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONSECUTIVE_N}] ${MODELPARAM_VALUE.CONSECUTIVE_N}
}

