# 1. input 5 wrong password, account will be locked 600s
# 2. no action 600s, session will closed.

class sys_security_access::login 
(
	$logout_timeout = '600',
	$unlock_timeout = '600'
)
{
	file { "/etc/profile.d/timeout.sh":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> 'TMOUT=$logout_timeout',
	}

	file { "/etc/pam.d/login":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template("sys_security_access/pam_login.erb"),
	}

	file { "/etc/pam.d/sshd":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template("sys_security_access/pam_sshd.erb"),
	}

}