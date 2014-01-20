require "spec_helper"

RSpec.describe AltStruct::VERSION do
  it "should be a string" do
    expect(AltStruct::VERSION).to be_kind_of(String)
  end
end
