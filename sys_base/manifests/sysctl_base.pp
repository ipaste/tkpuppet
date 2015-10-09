# 1. setup the kernel parameter
# 2. do the sysctl -p command when parameter is modify

class sys_base::sysctl_base {

	exec { "add_dir":
    	command => "/bin/mkdir /etc/sysctl.d",
    	creates => "/etc/sysctl.d/",
	}


	file { '/etc/sysctl.d/00_sys_base.conf':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		recurse		=> 'true',
		content		=> template('sys_base/sysctl_00_sys_base.conf.erb'),
		require		=> Exec['add_dir'],
	}

	exec { "enable_sysctl":
		command 	=> "/sbin/sysctl -e -p /etc/sysctl.d/00_sys_base.conf",
		require		=> File['/etc/sysctl.d/00_sys_base.conf'],
		subscribe	=> File['/etc/sysctl.d/00_sys_base.conf'],
		refreshonly => true,
	}
}
