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
ExecStep $xv_path/bin/xsim neopixels_tb_behav -key {Behavioral:sim_1:Functional:neopixels_tb} -tclbatch neopixels_tb.tcl -log simulate.log
