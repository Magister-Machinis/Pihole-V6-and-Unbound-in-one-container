# Pihole-V6-and-Unbound-in-one-container

A quick effort to modify the docker version of pihole (kudos to the folks at https://github.com/pi-hole/docker-pi-hole for doing the heavy lifting) to embed unbound and allow the single container to serve as an authoritative dns and dhcp server in one go. 

To use, configure the below env variables in stack.env, build, and deploy via docker compose or portainer (or your preferrence if you don't mind doing your own testing). Once you have pihole configured as you'd like, you can either use the in-built teleporter feature to export a backup and keep it somewhere safe, or extract /etc/pihole/pihole.toml from the container, drop it next to the compose files, and uncomment the volume reference to use that to persist configuration.

dnsmasq.d maps to the appropriate folder in the container for adding additional dnsmasq options, there's one item in there to better facillitate unbound interoptability.

settings in stack.env

pi and container settings
* PIVERSION= version of pihole to use (refer to https://github.com/pi-hole/docker-pi-hole/releases)
* IPVLANINTERFACE=interface on host to use for macvlan network
* SUBNET= cidr notation for network pihole is connecting too
* IPADDRESS= address to assign to pihole
* PASSWORD= login password for pihole 

dhcp settings, set FTLCONF_dhcp_active to false and remove these (except DHCP_ROUTER) if you don't want to use dhcp options
* DHCP_START= 
* DHCP_END=
* DHCP_ROUTER= network gateway, used for macvlan config too
* DHCP_LEASE= lease time, can accept formats such as 2d, 6h, etc

* DNS_DOMAIN=

  You may see a warning from unbound saying something to the tune of:
  * warning: so-rcvbuf 1048576 was not granted. Got 425984
 
  From what I have read it's not a dealbreaker, but if you notice problems and suspect this to be the cause, the below commands can alleviate matters.
  * sudo sysctl -w net.core.rmem_max=4194304
  * sudo sysctl -w net.core.wmem_max=4194304
 To make this change persist across reboots, add net.core.rmem_max=4194304 and net.core.wmem_max=4194304 to /etc/sysctl.conf.

