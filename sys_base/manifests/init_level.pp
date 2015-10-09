# 1. set the run level to 3(text)
# 2. disable ctrl+alt+del reboot the system

class sys_base::init_level (
	
	$init_gui		= false

){

	if $init_gui	== true {
		$init_level = 5
	} else {
		$init_level = 3
	}
	file { '/etc/inittab':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '644',
		content		=> "id:$init_level:initdefault:"
	}

	file { '/etc/init/control-alt-delete.conf':
		ensure		=> absent,
	}
}