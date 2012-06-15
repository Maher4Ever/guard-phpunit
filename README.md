Guard::PHPUnit [![Build Status](https://secure.travis-ci.org/Maher4Ever/guard-phpunit.png)](http://travis-ci.org/Maher4Ever/guard-phpunit) [![Dependency Status](https://gemnasium.com/Maher4Ever/guard-phpunit.png?branch=master)](https://gemnasium.com/Maher4Ever/guard-phpunit)
==============

Guard-phpunit allows you to automatically run [PHPUnit][6] tests when sources
are modified. It helps with integrating test-driven development (TDD) into
your development process: Just launch guard-phpunit before you start working
and it will notify you about the status of your tests!

*Note*: Although guard-phpunit should work with any [PHP][7] version [PHPUnit][6] supports,
it has only been tested on [PHP][7] 5.3.8 and 5.4.4.

Install
-------

Please be sure to have [PHP][7], [PHPUnit][6] and [Ruby][1] installed on your machine before
you proceed with the installation.

The latest versions of [Ruby][1] come with a packages-manager called `gem`. `gem` can be used to
install various packages, including guard-phpunit.

To install guard-phpunit, run the following command in the terminal:

```shell
$ gem install guard-phpunit
```

Usage
-----

Please read the [Guard usage documentation][3].

Guardfile
---------

Guard-phpunit can be used with any kind of [PHP][7] projects that uses PHPUnit as
its testing framwork. Please read the [Guard documentation][3] for more information
about the Guardfile DSL.

By default, guard-phpunit will use the current working directory (pwd) to
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

:all_after_pass => false      # Run all tests after changed tests pass. This ensures
                              # that the process of making changed tests pass didn't
                              # break something else.
                              # default: true

:keep_failed => false         # Remember failed tests and keep running them with
                              # each change until they pass.
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
[3]:https://github.com/guard/guard#readme
[4]:http://www.phpunit.de/manual/current/en/
[5]:https://github.com/sebastianbergmann/php-object-freezer/
[6]:http://www.phpunit.de
[7]:http://php.net
