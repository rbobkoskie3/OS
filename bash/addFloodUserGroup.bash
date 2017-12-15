#! /usr/bin/env bash

# rb868x 677 Feb 10 14:56 addFloodUserGroup.bash

# Add "flood" groups:
groupadd -g 2200 floodcod
groupadd -g 2101 flood
groupadd -g 2202 floodadm
groupadd -g 2203 floodanl
groupadd -g 2204 floodshr
groupadd -g 2105 floodxfr



# Add "flood" users:
useradd -u 2200 -g 2200 floodcod
useradd -u 2101 -g 2101 flood
useradd -u 2202 -g 2202 floodadm
useradd -u 2203 -g 2203 floodanl
useradd -u 2204 -g 2204 floodshr
useradd -u 2105 -g 2105 floodxfr

# Modify "flood" user groups:
usermod -aG flood,floodxfr,floodshr,floodcod flood
usermod -aG flood,floodxfr,floodshr floodxfr
usermod -aG floodcod,floodadm floodcod
usermod -aG flood,floodxfr,floodshr floodshr
