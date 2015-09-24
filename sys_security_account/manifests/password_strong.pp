class sys_security_account::password_strong {
	file { "/etc/pam.d/system-auth":
		ensure		=> 'present',
		owner		=> 'root',
		group		=> 'root',
		mode		=> '440',
		content		=> template("sys_security_account/pam_system-auth.erb"),
	}
}
