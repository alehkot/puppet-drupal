How to Use
=========

Quick sample usage

    class { 'drupal':
      install_location => '/var/www/drupal',
      db_user          => 'drupal',
      db_pass          => '123',
      require => [Mysql::Db['drupal']]
    }

Dependencies
=========

* [puppetlabs-vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)

Requirements
=========

* PHP > 5.2.4
    * php5-gd
* Webserver
    * Apache
    * Nginx
* Database
    * MySQL
        * SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER
    * MariaDB
        * SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER
    * PostgreSQL
        * ???
    * SQLite
        * Writable datafile

What's all this then?
===========

Easy way to setup Drupal on a PuPHPet-created VM.
