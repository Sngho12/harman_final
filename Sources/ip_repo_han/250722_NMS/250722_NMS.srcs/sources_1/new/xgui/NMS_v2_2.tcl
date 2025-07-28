# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set DATA_SIZE [ipgui::add_group $IPINST -name "DATA SIZE" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "DATA_SIZE" -parent ${DATA_SIZE}
  ipgui::add_static_text $IPINST -name "description for data size" -parent ${DATA_SIZE} -text {data size = score size +  1(is_dark) + 1(is bright)}

  #Adding Group
  set FRAME_SIZE [ipgui::add_group $IPINST -name "FRAME SIZE" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "FRAME_HEIGHT" -parent ${FRAME_SIZE}
  ipgui::add_param $IPINST -name "LINE_LENGTH" -parent ${FRAME_SIZE}

  #Adding Group
  set DETECTION_LIMIT [ipgui::add_group $IPINST -name "DETECTION_LIMIT" -parent ${Page_0} -display_name {DETECTION_LIMIT}]
  ipgui::add_param $IPINST -name "INNER_SIZE_X" -parent ${DETECTION_LIMIT}
  ipgui::add_param $IPINST -name "INNER_SIZE_Y" -parent ${DETECTION_LIMIT}
  ipgui::add_param $IPINST -name "INNER_DETECT_NUM_LIMIT" -parent ${DETECTION_LIMIT}
  ipgui::add_param $IPINST -name "OUTER_DETECT_NUM_LIMIT" -parent ${DETECTION_LIMIT}



}

proc update_PARAM_VALUE.DATA_SIZE { PARAM_VALUE.DATA_SIZE } {
	# Procedure called to update DATA_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_SIZE { PARAM_VALUE.DATA_SIZE } {
	# Procedure called to validate DATA_SIZE
	return true
}

proc update_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to update FRAME_HEIGHT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRAME_HEIGHT { PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to validate FRAME_HEIGHT
	return true
}

proc update_PARAM_VALUE.INNER_DETECT_NUM_LIMIT { PARAM_VALUE.INNER_DETECT_NUM_LIMIT } {
	# Procedure called to update INNER_DETECT_NUM_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INNER_DETECT_NUM_LIMIT { PARAM_VALUE.INNER_DETECT_NUM_LIMIT } {
	# Procedure called to validate INNER_DETECT_NUM_LIMIT
	return true
}

proc update_PARAM_VALUE.INNER_SIZE_X { PARAM_VALUE.INNER_SIZE_X } {
	# Procedure called to update INNER_SIZE_X when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INNER_SIZE_X { PARAM_VALUE.INNER_SIZE_X } {
	# Procedure called to validate INNER_SIZE_X
	return true
}

proc update_PARAM_VALUE.INNER_SIZE_Y { PARAM_VALUE.INNER_SIZE_Y } {
	# Procedure called to update INNER_SIZE_Y when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INNER_SIZE_Y { PARAM_VALUE.INNER_SIZE_Y } {
	# Procedure called to validate INNER_SIZE_Y
	return true
}

proc update_PARAM_VALUE.LINE_LENGTH { PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to update LINE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINE_LENGTH { PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to validate LINE_LENGTH
	return true
}

proc update_PARAM_VALUE.OUTER_DETECT_NUM_LIMIT { PARAM_VALUE.OUTER_DETECT_NUM_LIMIT } {
	# Procedure called to update OUTER_DETECT_NUM_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTER_DETECT_NUM_LIMIT { PARAM_VALUE.OUTER_DETECT_NUM_LIMIT } {
	# Procedure called to validate OUTER_DETECT_NUM_LIMIT
	return true
}


proc update_MODELPARAM_VALUE.DATA_SIZE { MODELPARAM_VALUE.DATA_SIZE PARAM_VALUE.DATA_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_SIZE}] ${MODELPARAM_VALUE.DATA_SIZE}
}

proc update_MODELPARAM_VALUE.LINE_LENGTH { MODELPARAM_VALUE.LINE_LENGTH PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LINE_LENGTH}] ${MODELPARAM_VALUE.LINE_LENGTH}
}

proc update_MODELPARAM_VALUE.FRAME_HEIGHT { MODELPARAM_VALUE.FRAME_HEIGHT PARAM_VALUE.FRAME_HEIGHT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRAME_HEIGHT}] ${MODELPARAM_VALUE.FRAME_HEIGHT}
}

proc update_MODELPARAM_VALUE.INNER_SIZE_X { MODELPARAM_VALUE.INNER_SIZE_X PARAM_VALUE.INNER_SIZE_X } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INNER_SIZE_X}] ${MODELPARAM_VALUE.INNER_SIZE_X}
}

proc update_MODELPARAM_VALUE.INNER_SIZE_Y { MODELPARAM_VALUE.INNER_SIZE_Y PARAM_VALUE.INNER_SIZE_Y } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INNER_SIZE_Y}] ${MODELPARAM_VALUE.INNER_SIZE_Y}
}

proc update_MODELPARAM_VALUE.INNER_DETECT_NUM_LIMIT { MODELPARAM_VALUE.INNER_DETECT_NUM_LIMIT PARAM_VALUE.INNER_DETECT_NUM_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INNER_DETECT_NUM_LIMIT}] ${MODELPARAM_VALUE.INNER_DETECT_NUM_LIMIT}
}

proc update_MODELPARAM_VALUE.OUTER_DETECT_NUM_LIMIT { MODELPARAM_VALUE.OUTER_DETECT_NUM_LIMIT PARAM_VALUE.OUTER_DETECT_NUM_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTER_DETECT_NUM_LIMIT}] ${MODELPARAM_VALUE.OUTER_DETECT_NUM_LIMIT}
}

