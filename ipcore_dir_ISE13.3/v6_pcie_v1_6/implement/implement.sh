#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir results

#Synthesize the Wrapper Files
echo 'Synthesizing example design with XST';
xst -ifn xilinx_pcie_2_0_ep_v6.cmd -ofn xilinx_pcie_2_0_ep_v6.log

cp xilinx_pcie_2_0_ep_v6.log xst.srp


if [ -f xilinx_pcie_2_0_ep_v6.ngc ]; then netgen -sim -ofmt vhdl -w -tm xilinx_pcie_2_0_ep_v6 xilinx_pcie_2_0_ep_v6.ngc
fi
cp xilinx_pcie_2_0_ep_v6.ngc ./results/


rm -rf *.mgo xlnx_auto_0_xdb xlnx_auto_0.ise netlist.lst smart



cd results

echo 'Running ngdbuild'
ngdbuild -verbose -uc ../../example_design/xilinx_pcie_2_0_ep_v6_04_lane_gen1_xc6vlx240t-ff1156-1_ML605.ucf xilinx_pcie_2_0_ep_v6.ngc -sd .


echo 'Running map'
map -u -timing -ol high -xe c -o mapped.ncd \
  -t 1 \
  xilinx_pcie_2_0_ep_v6.ngd \
  mapped.pcf

echo 'Running par'
par -ol high -xe c -w mapped.ncd \
  routed.ncd \
  mapped.pcf

echo 'Running trce'
trce -u -v 100 \
  routed.ncd \
  mapped.pcf

#echo 'Running design through netgen'
netgen -sim -ofmt vhdl -w -tm xilinx_pcie_2_0_ep_v6 routed.ncd

echo 'Running design through bitgen'
bitgen -w routed.ncd

echo 'Generating PROM file for programming'
promgen -w -p mcs -x xcf128x -data_width 16 -o ./ML605.mcs -u 0 ./routed.bit
