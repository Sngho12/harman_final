# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_static_text $IPINST -name "description for data size" -parent ${Page_0} -text {data size + is_dark + is bright}
  ipgui::add_param $IPINST -name "DATA_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "FRAME_HEIGHT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LINE_LENGTH" -parent ${Page_0}


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

proc update_PARAM_VALUE.LINE_LENGTH { PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to update LINE_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LINE_LENGTH { PARAM_VALUE.LINE_LENGTH } {
	# Procedure called to validate LINE_LENGTH
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

