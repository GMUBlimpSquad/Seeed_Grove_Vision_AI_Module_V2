#!/bin/bash

docker run --rm --volume .:/app -w /app/EPII_CM55M_APP_S grove make
cp EPII_CM55M_APP_S/obj_epii_evb_icv30_bdv10/gnu_epii_evb_WLCSP65/EPII_CM55M_gnu_epii_evb_WLCSP65_s.elf we2_image_gen_local/input_case1_secboot/ && docker run --rm --volume .:/app -w /app/we2_image_gen_local grove ./we2_local_image_gen project_case1_blp_wlcsp.json
