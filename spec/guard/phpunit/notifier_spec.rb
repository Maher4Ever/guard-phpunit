require 'spec_helper'

describe Guard::PHPUnit::Notifier do

  let(:guard_notifier) { Guard::Notifier }

  describe '.notify' do
    it 'calls the guard notifier' do
      guard_notifier.should_receive(:notify).with('My awesome message!', :image => :success)
      subject.notify('My awesome message!', :image => :success)
    end
  end

  describe '.notify_results' do
    context 'with no errors, failures or pending tests' do
      it 'displays a notification' do
        subject.should_receive(:notify).with(
          "10 tests, 0 failures\nin 5 seconds",
          :title => 'PHPUnit results',
          :image => :success
        )
        subject.notify_results(
          :tests  => 10, :failures => 0,
          :errors => 0, :pending  => 0,
          :duration => 5
        )
      end
    end
    context 'with errors or failures' do
      it 'displays a notification' do
        subject.should_receive(:notify).with(
          "10 tests, 3 failures\n4 errors\nin 6 seconds",
          :title => 'PHPUnit results',
          :image => :failed
        )
        subject.notify_results(
          :tests  => 10, :failures => 3,
          :errors => 4, :pending  => 0,
          :duration => 6
        )
      end
    end

    context 'with pending tests' do
      it 'displays a notification' do
        subject.should_receive(:notify).with(
          "10 tests, 0 failures (2 pending)\nin 4 seconds",
          :title => 'PHPUnit results',
          :image => :pending
        )
        subject.notify_results(
          :tests  => 10, :failures => 0,
          :errors => 0, :pending  => 2,
          :duration => 4
        )
      end

      it 'displays a notification (2)' do
        subject.should_receive(:notify).with(
          "10 tests, 0 failures\n3 errors (2 pending)\nin 4 seconds",
          :title => 'PHPUnit results',
          :image => :failed
        )
        subject.notify_results(
          :tests  => 10, :failures => 0,
          :errors => 3, :pending  => 2,
          :duration => 4
        )
      end
    end
  end
end
