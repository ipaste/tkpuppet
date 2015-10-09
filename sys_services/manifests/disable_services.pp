class sys_services::disable_services (
		$disabled_services = [ 
			iscsi,
			iscsid,
			anacron,
			atd,
			autofs,
			avahi-daemon,
			bluetooth,
			cpuspeed,
			cups,
			isdn,
			firstboot,
			gpm,
			hidd,
			hplip,
			ip6tables,
			iptables,
			mdmonitor,
			microcode_ctl,
			pcscd,
			postfix,
			xfs,
			xinetd,
			rhnsd,
			smartd,
			rhsmcertd,
			setroubleshoot,
			cmirror,
			modclusterd,
			netfs,
			tog-pegasus,
			yum-updatesd,
			mcstrans,
			lm_sensors,
			rawdevices,
			rpcgssd,
			rpcidmapd,
			restorecond,
			readahead_early,
			readahead_later,
			lvm2-monitor,
			nfslock,
			portmap,
			snmpd,
		]
	) 
	{

	define disable_service ($service = $title) {
		service { "$service":
			ensure		=> stopped,
			enable		=> false,
		}

	}
	
	disable_service{ $disabled_services: }

	
}