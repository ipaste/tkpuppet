#  1. setup ntp services as a client
#  2. setup ntp server
#  3. enable ntp service


class sys_services::ntp (

	$ntp_enable				= true,
	$ntp_services			= [
			'202.120.2.101',
			'202.112.29.82',
			'61.164.36.105',
	]

)
{

	package { 'ntp':
		ensure		=> 'installed',
	}

	file { '/etc/ntp.conf':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		require		=> Package['ntp'],
		content		=> template('sys_services/ntp.conf.erb'),
	}

	if $ntp_enable	== true {
		$service_enable	= true
		$service_ensure = 'running'
	} else {
		$service_enable = false
		$service_ensure	= 'stopped'
	}
	service {'ntpd':
		ensure		=> $service_ensure,
		enable		=> $service_enable,
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Package['ntp'],
		subscribe	=> File['/etc/ntp.conf'],
	}

}