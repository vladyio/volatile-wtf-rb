require 'spec_helper'

RSpec.describe Volatile::Cache do
  let(:cache) { Volatile::Cache.new }

  it "initializes with an empty storage hash" do
    expect(cache.storage).to eq({})
  end

  it "#save" do
    cache.save('key', 'value')
    expect(cache.storage).to eq({'key' => 'value'})
  end

  it "#fetch for an existing key" do
    cache.save('key', 'value')
    value = cache.fetch('key')
    expect(value).to eq('value')
  end

  it "#fetch for an absent key" do
    value = cache.fetch('totally_does_not_exist') { 'default' }
    expect(value).to eq('default')
  end
end
