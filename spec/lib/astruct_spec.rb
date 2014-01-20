require "spec_helper"

RSpec.describe AltStruct do
  let(:astruct) { described_class.new }

  it "should behave like AltStruct::Behavior" do
    expect(astruct).to respond_to(*AltStruct::Behavior.instance_methods)
  end

  it "should have aliases for standard methods" do
    expect(astruct).to respond_to(:__object_id__)
  end
end
