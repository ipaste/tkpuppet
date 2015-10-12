# 1. new deploy tomcat to hosts
# 2. setup tomcat init script
# 3. setup tomcat configure file

class application::tomcat (

	$tomcat_version		= '7.0.64'
	
) {
	
	package { 'java-1.7.0-openjdk.x86_64':
		ensure		=> 'installed',
	}

	package { 'cronolog':
		ensure		=> 'installed',
	}
	
	exec { "deploy_tomcat":
    	command => "/usr/bin/wget -P /tmp http://192.168.56.30/package/apache-tomcat-$tomcat_version.tar.gz; /bin/tar xzvf /tmp/apache-tomcat-$tomcat_version.tar.gz -C /opt ; /bin/ln -s /opt/apache-tomcat-$tomcat_version /opt/tomcat; /bin/rm -f /tmp/apache-tomcat-$tomcat_version.tar.gz " ,
    	path	=> "/usr/bin/:bin:/usr/sbin:/sbin",
    	creates => "/opt/tomcat",
	}

	file { '/opt/tomcat/bin/catalina.sh':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '755',
		content		=> template('application/tomcat_catalina.sh.erb'),
		require		=> Exec['deploy_tomcat'],
	}

		file { '/opt/tomcat/conf/server.xml':
		ensure		=> 'present',
		owner		=> 'root',
		group 		=> 'root',
		mode		=> '600',
		content		=> template('application/tomcat_server.xml.erb'),
		require		=> Exec['deploy_tomcat'],
	}

}