cd EPII_CM55M_APP_S && make
cd ..
cp EPII_CM55M_APP_S/obj_epii_evb_icv30_bdv10/gnu_epii_evb_WLCSP65/EPII_CM55M_gnu_epii_evb_WLCSP65_s.elf we2_image_gen_local/input_case1_secboot/
cd we2_image_gen_local && ./we2_local_image_gen project_case1_blp_wlcsp.json 
