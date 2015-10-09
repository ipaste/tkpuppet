# 1. setup max nproc ＝ 65535
# 2. setup max nfile ＝ 65535


class sys_base::sys_ulimit (

	$open_files		= '4096',
	$open_process	= '8192',

) {

	file { '/etc/security/limits.d/root3.conf':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> template('sys_base/ulimit_root3.conf.erb'),
	}
}
