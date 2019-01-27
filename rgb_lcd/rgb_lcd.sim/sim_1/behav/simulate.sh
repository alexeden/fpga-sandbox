#!/bin/sh -f
xv_path="/opt/Xilinx/Vivado/2014.3"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim lcd_tb_behav -key {Behavioral:sim_1:Functional:lcd_tb} -tclbatch lcd_tb.tcl -log simulate.log
