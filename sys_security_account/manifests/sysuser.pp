
class sys_security_account::sysuser (
	$sysadm_passwd = "$6$9bRH.A.Y3TKRmk81$NF5P5xRUDlNo53mKwW/cojtaRGN6gUjKvAheUGliZIi92Fc1nN7HNs9MqLLe7QqWDcnnN7V2MeW98W6.6HdlL0",
	$sysmon_passwd = "$6$9bRH.A.Y3TKRmk81$NF5P5xRUDlNo53mKwW/cojtaRGN6gUjKvAheUGliZIi92Fc1nN7HNs9MqLLe7QqWDcnnN7V2MeW98W6.6HdlL0"
){

	group { 'sysadm':
		ensure		=> 'present',
		gid			=> '901',
	}

	user { 'sysadm':
		ensure		=> 'present',
		uid			=> '901',
		gid			=> '901',
		groups		=> ['wheel'],
		password	=> "$sysadm_passwd",
		shell		=> '/bin/bash',
		home		=> '/home/sysmon',
		managehome	=> true,
	}

	file { '/etc/pam.d/su':
		ensure		=> 'present',
		path		=> /etc/pam.d/su',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template('sys_security_account/pam_su.erb'),
	}

	file { '/etc/sudoers.d/sysadm':
		ensure		=> 'present',
		path		=> '/etc/sudoers.d/sysadm',
		owner		=> 'root',
		group		=> 'root',
		mode		=> '440',
		content		=> template("sys_security_account/sudo_sysadm.erb"),
	}

	group { 'sysmon':
		ensure		=> 'present',
		gid			=> '902',
	}
	user { 'sysmon':
		ensure		=> 'present',
		uid			=> '902',
		gid			=> '902',
		password 	=> "$sysmon_passwd",
		shell		=> '/bin/bash',
		home		=> '/home/sysmon',
		managehome	=> true,
	}
	file { '/etc/sudoers.d/sysmon':
		ensure		=> 'present',
		path		=> '/etc/sudoers.d/sysmon',
		owner		=> 'root',
		group		=> 'root',
		mode		=> '440',
		content		=> template("sys_security_account/sudo_sysmon.erb"),
	}
		
}
