Guard::PHPUnit [![Build Status](https://secure.travis-ci.org/Maher4Ever/guard-phpunit.png)](http://travis-ci.org/Maher4Ever/guard-phpunit)
==============

PHPUnit guard allows to automatically & intelligently launch tests when files
are modified.

Tested on MRI Ruby 1.8.7, 1.9.2 and 1.9.3.

Install
-------

Please be sure to have [Ruby][1] running on your machine.
The latest versions of Ruby come with a packages-manger called Gem. Gem can be used to
install various packages, including PHPUnit guard.

Before you continue, also make sure you have the [Guard][2] gem installed

To install the PHPUnit gem, run the following command in the terminal:

    gem install guard-phpunit

Usage
-----

Please read the [Guard usage documentation][3].

Guardfile
---------

Guard::PHPUnit can be used with any kind of PHP projects that uses PHPUnit as
its testing framwork. Please read the [Guard documentation][3] for more information
about the Guardfile DSL.

By default, Guard::PHPUnit will use the current working directory (pwd) to
search for tests and run them on start (if you enabled the `:all_on_start` option).

### Example PHP project

The [PHPUnit documentaion][4] uses the [Object Freezer][5] library as an example on how
to organize tests. This project uses the `Tests` directory for its tests.

An example of the Guardfile for the same project would look
something like:

```ruby
guard 'phpunit', :tests_path => 'Tests', :cli => '--colors' do
  # Watch tests files
  watch(%r{^.+Test\.php$})

  # Watch library files and run their tests
  watch(%r{^Object/(.+)\.php}) { |m| "Tests/#{m[1]}Test.php" }
end
```

Options
-------

The following options can be passed to Guard::PHPUnit:

```ruby
:all_on_start => false        # Run all tests on startup.
                              # default: true

:tests_path => 'tests'        # Relative path to the tests directory. This path
                              # is used when running all the tests.
                              # default: the current working directory (pwd)

:cli => '--colors'            # The options passed to the phpunit command
                              # when running the tests.
                              # default: nil
```

Development
-----------

* Source hosted at [GitHub](https://github.com/Maher4Ever/guard-phpunit)
* Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/Maher4Ever/guard-phpunit/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please create a topic branch for every separate change
you make.

Author
------

[Maher Sallam](https://github.com/Maher4Ever)

[1]:http://ruby-lang.org
[2]:https://github.com/guard/guard
[3]:https://github.com/guard/guard#readme
[4]:http://www.phpunit.de/manual/current/en/
[5]:https://github.com/sebastianbergmann/php-object-freezer/
