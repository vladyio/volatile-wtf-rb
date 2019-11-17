require 'spec_helper'

RSpec.describe VolatileWtf do
  it "has a version number" do
    expect(VolatileWtf::VERSION).not_to be nil
  end
end

RSpec.describe Volatile do
  it "has BASE_URL" do
    expect(Volatile::BASE_URL).not_to be nil
  end
end
