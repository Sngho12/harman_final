# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set ADRESS_SIZE [ipgui::add_group $IPINST -name "ADRESS SIZE" -parent ${Page_0} -display_name {ADDRESS SIZE}]
  set_property tooltip {ADDRESS SIZE} ${ADRESS_SIZE}
  ipgui::add_param $IPINST -name "X_WIDTH" -parent ${ADRESS_SIZE}
  ipgui::add_param $IPINST -name "Y_WIDTH" -parent ${ADRESS_SIZE}

  #Adding Group
  set PAIR_NUM [ipgui::add_group $IPINST -name "PAIR NUM" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "MINIMUM_PAIR_NUM" -parent ${PAIR_NUM}
  ipgui::add_param $IPINST -name "MAXIMUM_PAIR_NUM" -parent ${PAIR_NUM}

  #Adding Group
  set ADJUST_AFFINE_LIMITATION [ipgui::add_group $IPINST -name "ADJUST AFFINE LIMITATION" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "ADJUST_AFFINE_DX_THRES" -parent ${ADJUST_AFFINE_LIMITATION}
  ipgui::add_param $IPINST -name "ADJUST_AFFINE_DY_THRES" -parent ${ADJUST_AFFINE_LIMITATION}



}

proc update_PARAM_VALUE.ADJUST_AFFINE_DX_THRES { PARAM_VALUE.ADJUST_AFFINE_DX_THRES } {
	# Procedure called to update ADJUST_AFFINE_DX_THRES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADJUST_AFFINE_DX_THRES { PARAM_VALUE.ADJUST_AFFINE_DX_THRES } {
	# Procedure called to validate ADJUST_AFFINE_DX_THRES
	return true
}

proc update_PARAM_VALUE.ADJUST_AFFINE_DY_THRES { PARAM_VALUE.ADJUST_AFFINE_DY_THRES } {
	# Procedure called to update ADJUST_AFFINE_DY_THRES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADJUST_AFFINE_DY_THRES { PARAM_VALUE.ADJUST_AFFINE_DY_THRES } {
	# Procedure called to validate ADJUST_AFFINE_DY_THRES
	return true
}

proc update_PARAM_VALUE.MAXIMUM_PAIR_NUM { PARAM_VALUE.MAXIMUM_PAIR_NUM } {
	# Procedure called to update MAXIMUM_PAIR_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAXIMUM_PAIR_NUM { PARAM_VALUE.MAXIMUM_PAIR_NUM } {
	# Procedure called to validate MAXIMUM_PAIR_NUM
	return true
}

proc update_PARAM_VALUE.MINIMUM_PAIR_NUM { PARAM_VALUE.MINIMUM_PAIR_NUM } {
	# Procedure called to update MINIMUM_PAIR_NUM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MINIMUM_PAIR_NUM { PARAM_VALUE.MINIMUM_PAIR_NUM } {
	# Procedure called to validate MINIMUM_PAIR_NUM
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


proc update_MODELPARAM_VALUE.X_WIDTH { MODELPARAM_VALUE.X_WIDTH PARAM_VALUE.X_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.X_WIDTH}] ${MODELPARAM_VALUE.X_WIDTH}
}

proc update_MODELPARAM_VALUE.Y_WIDTH { MODELPARAM_VALUE.Y_WIDTH PARAM_VALUE.Y_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Y_WIDTH}] ${MODELPARAM_VALUE.Y_WIDTH}
}

proc update_MODELPARAM_VALUE.ADJUST_AFFINE_DX_THRES { MODELPARAM_VALUE.ADJUST_AFFINE_DX_THRES PARAM_VALUE.ADJUST_AFFINE_DX_THRES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADJUST_AFFINE_DX_THRES}] ${MODELPARAM_VALUE.ADJUST_AFFINE_DX_THRES}
}

proc update_MODELPARAM_VALUE.ADJUST_AFFINE_DY_THRES { MODELPARAM_VALUE.ADJUST_AFFINE_DY_THRES PARAM_VALUE.ADJUST_AFFINE_DY_THRES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADJUST_AFFINE_DY_THRES}] ${MODELPARAM_VALUE.ADJUST_AFFINE_DY_THRES}
}

proc update_MODELPARAM_VALUE.MAXIMUM_PAIR_NUM { MODELPARAM_VALUE.MAXIMUM_PAIR_NUM PARAM_VALUE.MAXIMUM_PAIR_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAXIMUM_PAIR_NUM}] ${MODELPARAM_VALUE.MAXIMUM_PAIR_NUM}
}

proc update_MODELPARAM_VALUE.MINIMUM_PAIR_NUM { MODELPARAM_VALUE.MINIMUM_PAIR_NUM PARAM_VALUE.MINIMUM_PAIR_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MINIMUM_PAIR_NUM}] ${MODELPARAM_VALUE.MINIMUM_PAIR_NUM}
}

