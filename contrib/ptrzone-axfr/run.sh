#!/bin/bash

# Quick-and-dirty test harness for IPv6/v4 PTR zone transfer feature
# Author: Daniel Bromberg daniel@basezen.com

# Copyright 2020 Daniel Bromberg
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program*; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# Daniel Bromberg, daniel@basezen.com

# Requirements:

# 1. GNU toolchain installed
# 2. Nothing running on port chosen below
# 3. 'dig' tool installed

top=../..
port=5053

start=$(date +'%Y-%m-%d-%H%M.%S')

make -C ${top}

mkdir -p ./output

${top}/src/dnsmasq --no-daemon --log-queries --port ${port} --conf-file=./dnsmasq.conf > ./output/server-out.${start} 2>&1 &

exec 3>&1
exec 1>output/client-out.${start}
echo "** Reverse IPv6 zone transfer **"
dig -t AXFR -q 2.1.0.0.d.c.b.a.8.b.d.0.1.0.0.2.ip6.arpa -p ${port} @localhost
echo "** Reverse IPv4 zone transfer **"
dig -t AXFR -q 2.1.10.in-addr.arpa -p ${port} @localhost
echo "** Forward IPv6 zone transfer **"
dig -t AXFR -q ipv6.example.com -p ${port} @localhost
echo "** Forward IPv4 zone transfer **"
dig -t AXFR -q ipv4.example.com -p ${port} @localhost
exec 1>&3

kill %1
