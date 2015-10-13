# 1. Let system log the user's shell  and log the detail message into history.
# 2. save system security log 3 month,such as /var/log/secure, /var/log/audit/audit.log

class sys_security_access::log 
{
	file { "/etc/profile.d/his_log.sh":
		ensure		=> 'present',
		path		=> '/etc/profile.d/his_log.sh',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> 'HISTTIMEFORMAT="[%F %T][`whoami`][`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`] "',
	}

	file { "/etc/logrotate.d/secure":
		ensure		=> 'present',
		path		=> '/etc/logrotate.d/secure',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template("sys_security_access/log_secure.erb"),
	}
	file { "/etc/logrotate.d/audit":
		ensure		=> 'present',
		path		=> '/etc/logrotate.d/audit',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template("sys_security_access/log_audit.erb"),
	}

	
}
