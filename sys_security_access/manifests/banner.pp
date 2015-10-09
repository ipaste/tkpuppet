# 1. modify issue and issue.net,this message will show before login.
# 2. add login warning message to motd,this message will show after login.

class sys_security_access::banner (
	$issue_message 	= 'Welcome to Taikang Linux System\n',
	$issue_net_message 	= 'Welcome to Taikang Linux System\n',
	$motd_message	= 'Warning,Be carefully '
)
{

	file { "/etc/issue":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> "$issue_message",
	}
	file { "/etc/issue.net":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> "$issue_net_message",
	}
	file { "/etc/motd":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> "$motd_message",
	}
}
