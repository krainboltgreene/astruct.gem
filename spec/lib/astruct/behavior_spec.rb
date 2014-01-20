require "spec_helper"

describe AltStruct::Behavior do
  class ExampleAltStruct
    include AltStruct::Behavior
  end

  let(:pairs) { {} }
  let(:astruct) { ExampleAltStruct.new(pairs) }
end
