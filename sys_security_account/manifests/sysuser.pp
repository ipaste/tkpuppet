# 1. add user sysadm, default password is taikang123
# 2. setup sysadm can su to root,other user can't su to root
# 3. setup sysadm can use sudo run system command
# 4. add user sysmon, default password is taikang123
# 5. setup sysadm can use sudo run monitor command
# 6. If you want modify the password of sysadmin,you can run "grub-md5-crypt" and set it in the foreman.

class sys_security_account::sysuser (
	$sysadm_passwd = '$1$eRWSR$KIWqmyai5VoyxdvjDttdT0',
	$sysmon_passwd = '$1$eRWSR$KIWqmyai5VoyxdvjDttdT0',
)
{

	group { 'sysadm':
		ensure		=> 'present',
		gid			=> '901',
	}

	user { 'sysadm':
		ensure		=> 'present',
		uid			=> '901',
		gid			=> '901',
		groups		=> 'wheel',
		password	=> "$sysadm_passwd",
		shell		=> '/bin/bash',
		home		=> '/home/sysadm',
		managehome	=> true,
	}

	file { '/etc/pam.d/su':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template("sys_security_account/pam_su.erb"),
	}

	file { '/etc/sudoers.d/sysadm':
		ensure		=> 'present',
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
		owner		=> 'root',
		group		=> 'root',
		mode		=> '440',
		content		=> template("sys_security_account/sudo_sysmon.erb"),
	}
		
}
