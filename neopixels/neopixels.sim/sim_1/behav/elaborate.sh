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
ExecStep $xv_path/bin/xelab -wto b807e61c89804bf1b48286f81948c91d -m64 --debug typical --relax -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot neopixels_tb_behav xil_defaultlib.neopixels_tb xil_defaultlib.glbl -log elaborate.log
