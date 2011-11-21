require 'spec_helper'

describe Guard::PHPUnit::Inspector do
  before do
    subject.tests_path = 'spec/fixtures'
  end

  describe 'clean' do
    it 'removes non-tests files' do
      subject.clean(['spec/fixtures/sampleTest.php', 'foo.php']).should == ['spec/fixtures/sampleTest.php']
    end

    it 'removes test-looking but non-existing files' do
      subject.clean(['spec/fixtures/sampleTest.php', 'fooTest.rb']).should == ['spec/fixtures/sampleTest.php']
    end

    it 'removes test-looking but non-existing files (2)' do
      subject.clean(['spec/fixtures/fooTest.php']).should == []
    end

    it 'removes duplicate files' do
      subject.clean(['spec/fixtures/sampleTest.php', 'spec/fixtures/sampleTest.php']).should == ['spec/fixtures/sampleTest.php']
    end

    it 'remove nil files' do
      subject.clean(['spec/fixtures/sampleTest.php', nil]).should == ['spec/fixtures/sampleTest.php']
    end

    it 'frees up the list of tests files' do
      subject.should_receive(:clear_tests_files_list)
      subject.clean(['classTest.php'])
    end
  end
end
