# frozen_string_literal: true

require_relative 'helper'

describe Fixer do
  before do
    @mock = MiniTest::Mock.new
  end

  after do
    @mock.verify
  end

  it 'returns current rates' do
    @mock.expect(:call, nil, [:current])
    Fixer::Feed.stub(:new, @mock) do
      Fixer.current
    end
  end

  it 'returns ninety-day rates' do
    @mock.expect(:call, nil, [:ninety_days])
    Fixer::Feed.stub(:new, @mock) do
      Fixer.ninety_days
    end
  end

  it 'returns historical rates' do
    @mock.expect(:call, nil, [:historical])
    Fixer::Feed.stub(:new, @mock) do
      Fixer.historical
    end
  end
end
