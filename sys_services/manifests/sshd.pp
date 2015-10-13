#  1. setup sshd services 
#  2. disabled root remote login
#  3. sftp secure setup
#  4. setup the sshd package version
#  5. enabled sshd services

class sys_services::sshd (

	$sshd_port				= '22',
	$remote_root_login		= false,
	$package_version		= ''

)
{
	if $package_version == '' {
		$package_status	= 'installed'
	} else {
		$package_status = $package_version
	}

	package { 'openssh-server':
		ensure		=> $package_status,
	}

	file { '/etc/ssh/sshd_config':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '600',
		require		=> Package['openssh-server'],
		content		=> template('sys_services/sshd_config.erb'),
	}

	file { '/etc/ssh/ssh_banner':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '600',
		require		=> Package['openssh-server'],
		content		=> template('sys_services/sshd_banner.erb'),
	}

	service { "sshd":
			ensure		=> 'running',
			enable		=> true,
			hasstatus	=> true,
			hasrestart	=> true,
			require		=> Package['openssh-server'],
			subscribe	=> File['/etc/ssh/sshd_config'],
		}

}