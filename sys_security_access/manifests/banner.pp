# 1. modify issue and issue.net
# 2. add login warning message to motd
class sys_security_access::banner (
	$issue_message 	= 'Welcome to Taikang Linux System',
	$issue_net_message 	= 'Welcome to Taikang Linux System',
	$motd_message	= 'Warning'
) 
{

	file { "/etc/issue":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> '$issue_message',
	}
	file { "/etc/issue.net":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> '$issue_net_message',
	}
	file { "/etc/motd":
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> '$motd_message',
	}
}
