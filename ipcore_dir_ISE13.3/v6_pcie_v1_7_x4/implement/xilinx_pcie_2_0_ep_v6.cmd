run 
-p xc6vlx240t-ff1156-1
-ifn xilinx_pcie_2_0_ep_v6.prj
-ifmt mixed
-ofn xilinx_pcie_2_0_ep_v6.ngc  
-use_dsp48 no
-bufg 0
-top xilinx_pcie_2_0_ep_v6
-opt_mode  SPEED
-opt_level 2
-max_fanout 100
#-keep_hierarchy yes
-rtlview yes
-use_sync_reset yes
-uc xilinx_pcie_2_0_ep_v6.xcf
