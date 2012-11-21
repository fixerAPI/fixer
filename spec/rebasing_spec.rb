require_relative 'helper'
require 'snapshot'

describe 'when rebased to a new base' do
  let(:base)     { 'USD' }
  let(:snapshot) { Snapshot.new 'a date' }
  let(:rates)    { { 'USD' => 1.2781 } }
  let(:rebased) do
    snapshot.stub :rates, rates do
      snapshot.to_base base
    end
  end

  it 'resets base' do
    rebased[:base].must_equal base
  end

  it 'adds former base to rates' do
    rebased[:rates].keys.must_include 'EUR'
  end

  it 'removes new base from rates' do
    rebased[:rates].keys.wont_include base
  end

  it 'rebases rates' do
    rebased[:rates]['EUR'].must_equal 0.7824
  end
end
