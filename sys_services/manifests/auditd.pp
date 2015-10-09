# 1. enable auditd service
# 2. setup audit security action (yes or no)
# 3. setup audit file action on sysconfig and audit file

class sys_services::auditd (
	$auditd_enable	= true,
	$audit_security = false 
)
{
	package { 'audit' :
		ensure		=> installed,
	}

	file { '/etc/audit/auditd.conf':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '640',
		require		=> Package['audit'],
		content		=> template('sys_services/auditd.conf.erb'),
	}

	file { '/etc/audit/audit.rules':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '640',
		require		=> Package['audit'],
		content		=> template('sys_services/audit.rules.erb'),
	}

	if $auditd_enable	== true {
		$service_enable	= true
		$service_ensure = 'running'
	} else {
		$service_enable = false
		$service_ensure	= 'stopped'
	}

	service {'auditd':
		ensure		=> $service_ensure,
		enable		=> $service_enable,
		hasstatus	=> true,
		hasrestart	=> true,
		require		=> Package['audit'],
		subscribe	=> File['/etc/audit/auditd.conf','/etc/audit/audit.rules'],
	}

}