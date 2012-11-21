require_relative 'helper'
require 'snapshot'

describe 'when rebased to a new base' do
  let(:new_base) { 'USD' }
  let(:snapshot) { Snapshot.new 'a date' }
  let(:rates)    { { new_base => 1.2781 } }
  let(:rebased_hash) do
    snapshot.stub :rates, rates do
      snapshot
        .with_base(new_base)
        .to_hash
    end
  end

  it 'resets base' do
    rebased_hash[:base].must_equal new_base
  end

  it 'adds former base to rates' do
    rebased_hash[:rates].keys.must_include Snapshot::DEFAULT_BASE
  end

  it 'removes new base from rates' do
    rebased_hash[:rates].keys.wont_include new_base
  end

  it 'rebases rates' do
    rebased_hash[:rates][Snapshot::DEFAULT_BASE].must_equal 0.7824
  end
end
