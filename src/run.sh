#!/bin/bash

start=$(date +'%Y-%m-%d-%H%M.%S')
port=5053

/root/dnsmasq/src/dnsmasq --no-daemon --log-queries --port ${port} --conf-file=/root/dnsmasq/test/dnsmasq.conf > run.${start} 2>&1 &
exec 3>&1
exec 1>results.${start}
echo "** Reverse IPv6 zone transfer **"
dig -t AXFR -q 0.0.0.0.2.1.0.0.d.c.b.a.8.b.d.0.1.0.0.2.ip6.arpa -p ${port} @localhost
echo "** Reverse IPv4 zone transfer **"
dig -t AXFR -q 65.1.10.in-addr.arpa -p ${port} @localhost
echo "** Forward IPv6 zone transfer **"
dig -t AXFR -q foohouse.thefoo.com -p ${port} @localhost
echo "** Forward IPv4 zone transfer **"
dig -t AXFR -q warehouse.thecoop.com -p ${port} @localhost
exec 1>&3
kill %1
