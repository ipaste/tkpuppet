class sys_security_net::sysctl_net {

	exec { "add_dir":
    	command => "/bin/mkdir /etc/sysctl.d",
    	creates => "/etc/sysctl.d/",
	}


	file { '/etc/sysctl.d/00_net_security.conf':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		recurse		=> 'true',
		content		=> template('sys_security_net/sysctl_00_net_security.conf.erb'),
		require		=> Exec['add_dir'],
	}

	exec { "enable_sysctl":
		command 	=> "/sbin/sysctl -e -p /etc/sysctl.d/00_net_security.conf",
		require		=> File['/etc/sysctl.d/00_net_security.conf'],
		subscribe	=> File['/etc/sysctl.d/00_net_security.conf'],
		refreshonly => true,
	}
}
