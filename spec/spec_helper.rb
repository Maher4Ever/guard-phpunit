require 'rspec'
require 'guard/phpunit'

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.color_enabled = true
  config.filter_run :focus

  config.before(:each) do
    ENV['GUARD_ENV'] = 'test'
    @project_path    = Pathname.new(File.expand_path('../../', __FILE__))
  end

  config.after(:each) do
    ENV['GUARD_ENV'] = nil
  end

end

def load_phpunit_output(name)
  File.read(File.expand_path("fixtures/results/#{name}.txt", File.dirname(__FILE__)))
end
