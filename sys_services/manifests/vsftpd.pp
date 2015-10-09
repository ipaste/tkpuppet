#  1. setup sshd services 
#  2. disabled root ftp
#  3. disable anoymose
#  4. setup vsftpd version
#  5. disabled vsftpd

class sys_services::vsftpd (

	$anoymose_ftp			= false,
	$ftp_enable				= false,
	$ftp_banner_message		='Taikang Ftp Server, Be carefully!'

)
{

	package { 'vsftpd':
		ensure		=> 'installed',
	}

	file { '/etc/vsftpd/vsftpd.conf':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '600',
		require		=> Package['vsftpd'],
		content		=> template('sys_services/vsftpd.conf.erb'),
	}

	if $ftp_enable	== true {
		$service_enable	= true
		$service_ensure = 'running'
	} else {
		$service_enable = false
		$service_ensure	= 'stopped'
	}
	service {'vsftpd':
		ensure		=> $service_ensure,
		enable		=> $service_enable,
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Package['vsftpd'],
		subscribe	=> File['/etc/vsftpd/vsftpd.conf'],
	}

}