# Class: Drupal
#
# Installs Drupal
class drupal (
  $install_location,
  $tag          = '7.23',
  $account_mail = 'admin@example.com',
  $account_name = 'admin',
  $account_pass = 'test123',
  $clean_url    = 1,
  $db_type      = 'mysql',
  $db_su        = false,
  $db_su_pw     = false,
  $db_prefix    = false,
  $db_user,
  $db_pass,
  $db_host      = 'localhost',
  $db_port      = '3306',
  $db_name      = 'drupal',
  $locale       = 'en-US',
  $site_mail    = 'admin@example.com',
  $site_name    = 'Site-Install',
  $sites_subdir = 'default'
) {

  # Clone Drupal
  vcsrepo { $install_location:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/drupal/drupal.git',
    revision => $tag,
    user     => 'vagrant',
    require  => Package['git-core'],
  }

  # Clone Drush
  vcsrepo { '/home/vagrant/drush':
    ensure   => present,
    provider => git,
    source   => 'http://git.drupal.org/project/drush.git',
    revision => '8.x-6.x',
    user     => 'vagrant',
    require  => [
      Package['git-core'],
      Vcsrepo[$install_location]
    ]
  }

  # Make Drush executable
  file { '/home/vagrant/drush/drush.php':
    ensure  => 'present',
    mode    => 'a+X,ug+w',
    require => Vcsrepo['/home/vagrant/drush'],
  }

  # Make Drush system-wide
  file { '/usr/local/bin/drush':
    ensure  => 'link',
    target  => '/home/vagrant/drush/drush.php',
    require => File['/home/vagrant/drush/drush.php'],
  }

  # Construct Drush options
  $a_m   = "--account-mail=${account_mail}"
  $a_n   = "--account-name=${account_name}"
  $a_p   = "--account-pass=${account_pass}"
  $c_u   = "--clean-url=${clean_url}"
  $d_p   = $db_prefix ? {
    false   => '',
    default => "--db-prefix=${db_prefix}"
  }
  $d_s   = $db_su ? {
    false   => '',
    default => "--db-su=${db_su}"
  }
  $d_s_p = $db_su_pw ? {
    false   => '',
    default => "--db-su-pw=${db_su_pw}"
  }
  $d_u   = "--db-url=${db_type}://${db_user}:${db_pass}@${db_host}:${db_port}/${db_name}"
  $l     = "--locale=${locale}"
  $s_m   = "--site-mail=${site_mail}"
  $s_n   = "--site-name=${site_name}"
  $s_s   = "--sites-subdir=${sites_subdir}"

  $site_install = "${a_m} ${a_n} ${a_p} ${c_u} ${d_p} ${d_s} ${d_s_p} ${d_u} ${l} ${s_m} ${s_n} ${s_s}"

  exec { "touch ${install_location}/drush-run && yes | drush site-install ${site_install}":
    creates => "${install_location}/drush-run",
    path    => ['bin', '/usr/bin', '/usr/local/bin'],
    cwd     => $install_location,
    require => [
      Package['php'],
      File['/usr/local/bin/drush']
    ],
  }
}
