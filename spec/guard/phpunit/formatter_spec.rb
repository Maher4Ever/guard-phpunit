require 'spec_helper'

describe Guard::PHPUnit::Formatter do

  let(:notifier) { Guard::Notifier }

  describe '.parse_output' do
    context 'when all tests pass' do
      it 'returns a hash containing the tests result' do
        output = load_phpunit_output('passing') 
        subject.parse_output(output).should == {
          :tests  => 2, :failures => 0,
          :errors => 0, :pending  => 0,
          :duration => 0
        }
      end
    end

    context 'when all tests fail' do
      it 'returns a hash containing the tests result' do
        output = load_phpunit_output('failing') 
        subject.parse_output(output).should == {
          :tests  => 2, :failures => 2,
          :errors => 0, :pending  => 0,
          :duration => 0
        }
      end
    end

    context 'when tests are skipped or incomplete' do
      it 'returns a hash containing the tests result' do
        output = load_phpunit_output('skipped_and_incomplete') 
        subject.parse_output(output).should == {
          :tests  => 3, :failures => 0,
          :errors => 0, :pending  => 3,
          :duration => 0
        }
      end
    end

    context 'when tests have mixed statuses' do
      it 'returns a hash containing the tests result' do
        output = load_phpunit_output('mixed') 
        subject.parse_output(output).should == {
          :tests  => 9, :failures => 3,
          :errors => 1, :pending  => 3,
          :duration => 2
        }
      end
    end
  end

  describe '.notify' do
    context 'with no errors, failures or pending tests' do
      it 'calls the guard notifier' do
        notifier.should_receive(:notify).with(
          "10 tests, 0 failures\nin 5 seconds",
          :title => 'PHPUnit results',
          :image => :success
        )
        subject.notify(
          :tests  => 10, :failures => 0,
          :errors => 0, :pending  => 0,
          :duration => 5    
        )
      end
    end
    context 'with errors or failures' do
      it 'calls the guard notifier' do
        notifier.should_receive(:notify).with(
          "10 tests, 3 failures\n4 errors\nin 6 seconds",
          :title => 'PHPUnit results',
          :image => :failed
        )
        subject.notify(
          :tests  => 10, :failures => 3,
          :errors => 4, :pending  => 0,
          :duration => 6    
        )
      end
    end

    context 'with pending tests' do
      it 'calls the guard notifier' do
        notifier.should_receive(:notify).with(
          "10 tests, 0 failures (2 pending)\nin 4 seconds",
          :title => 'PHPUnit results',
          :image => :pending
        )
        subject.notify(
          :tests  => 10, :failures => 0,
          :errors => 0, :pending  => 2,
          :duration => 4
        )
      end

      it 'calls the guard notifier (2)' do
        notifier.should_receive(:notify).with(
          "10 tests, 0 failures\n3 errors (2 pending)\nin 4 seconds",
          :title => 'PHPUnit results',
          :image => :failed
        )
        subject.notify(
          :tests  => 10, :failures => 0,
          :errors => 3, :pending  => 2,
          :duration => 4
        )
      end
    end
  end
end
