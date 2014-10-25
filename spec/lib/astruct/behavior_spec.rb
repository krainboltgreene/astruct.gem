require "spec_helper"

describe AltStruct::Behavior do
  let(:pairs) { { a: 1, b: 2, c: 3} }
  let(:astruct) { ExampleAltStruct.new(pairs) }

  it "reponds to each key as a method" do
    expect(astruct).to have_attributes(pairs)
  end
end
