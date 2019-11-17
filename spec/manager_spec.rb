require 'spec_helper'

RSpec.describe Volatile::Manager do
  let (:manager) { Volatile::Manager.new }
  let (:key) { 'key' }
  let (:value) { 'value' }

  context "API URI builder" do
    it "returns correct URI for key" do
      built_uri = manager.send(:api_uri, key)
      expected_uri = URI("#{Volatile::BASE_URL}/?key=#{key}")

      expect(built_uri).to eq(expected_uri)
    end

    it "returns correct URI for key and value" do
      built_uri = manager.send(:api_uri, key, value)
      expected_uri = URI("#{Volatile::BASE_URL}/?key=#{key}&val=#{value}")

      expect(built_uri).to eq(expected_uri)
    end

    context "modifier uri" do
      it "returns correct URI for modifiers" do
        modifier = 'created'
        built_uri = manager.send(:api_uri, key, nil, modifier)
        expected_uri = URI("#{Volatile::BASE_URL}/?key=#{key}&#{modifier}")

        expect(built_uri).to eq(expected_uri)
      end
    end
  end
end