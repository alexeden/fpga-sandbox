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
ExecStep $xv_path/bin/xelab -wto 7dbb56ee41714139ae55bad369bb23bf -m64 --debug typical --relax -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot clockSpeedControl_tb_behav xil_defaultlib.clockSpeedControl_tb xil_defaultlib.glbl -log elaborate.log
