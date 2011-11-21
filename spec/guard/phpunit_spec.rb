require 'spec_helper'

describe Guard::PHPUnit do

  let(:runner)    { Guard::PHPUnit::Runner }
  let(:inspector) { Guard::PHPUnit::Inspector }
  let(:defaults)  { Guard::PHPUnit::DEFAULT_OPTIONS }

  describe '#initialize' do
    context 'when no options are provided' do
      it 'sets a default :all_on_start option' do
        subject.options[:all_on_start].should be_true
      end

      it 'sets a default :tests_path option' do
        subject.options[:tests_path].should == @project_path.to_s
      end
    end

    context 'when other options are provided' do

      subject { Guard::PHPUnit.new(nil, { :all_on_start => false,
                                          :cli          => '--colors',
                                          :tests_path   => 'tests'     }) }

      it 'sets :all_on_start with the provided option' do
        subject.options[:all_on_start].should be_false
      end

      it 'sets :cli with the provided option' do
        subject.options[:cli].should == '--colors'
      end

      it 'sets :tests_path with the provided option' do
        subject.options[:tests_path].should == 'tests'
      end
    end

    it 'sets the tests path for the inspector' do
      inspector.should_receive(:tests_path=).with(@project_path.to_s)
      subject
    end
  end

  # ----------------------------------------------------------

  describe '#start' do
    it 'calls #run_all' do
      subject.should_receive(:run_all)
      subject.start
    end

    context 'with the :all_on_start option set to false' do
      subject { Guard::PHPUnit.new(nil, :all_on_start => false) }

      it 'calls #run_all' do
        subject.should_not_receive(:run_all)
        subject.start
      end
    end
  end

  describe '#run_all' do
    it 'runs all tests in the tests path' do
      runner.should_receive(:run).with(defaults[:tests_path], anything).and_return(true)
      subject.run_all
    end

    it 'throws :task_has_failed when an error occurs' do
      runner.should_receive(:run).with(defaults[:tests_path], anything).and_return(false)
      expect { subject.run_all }.to throw_symbol :task_has_failed
    end

    it 'passes the options to the runner' do
      runner.should_receive(:run).with(anything, hash_including(defaults)).and_return(true)
      subject.run_all
    end
  end

  describe '#run_on_change' do
    it 'runs the changed tests' do
      runner.should_receive(:run).with(['tests/firstTest.php', 'tests/secondTest.php'], anything).and_return(true)
      subject.run_on_change ['tests/firstTest.php', 'tests/secondTest.php']
    end

    it 'throws :task_has_failed when an error occurs' do
      runner.should_receive(:run).with(['tests/firstTest.php', 'tests/secondTest.php'], anything).and_return(false)
      expect { subject.run_on_change ['tests/firstTest.php', 'tests/secondTest.php'] }.to throw_symbol :task_has_failed
    end 

    it 'passes the options to the runner' do
      runner.should_receive(:run).with(anything, hash_including(defaults)).and_return(true)
      subject.run_on_change ['tests/firstTest.php', 'tests/secondTest.php']
    end
  end
end
