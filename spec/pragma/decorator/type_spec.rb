# frozen_string_literal: true
RSpec.describe Pragma::Decorator::Type do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      feature Pragma::Decorator::Type
    end
  end

  let(:model) { OpenStruct.new }

  let(:result) { JSON.parse(subject.to_json) }

  it 'includes the object type' do
    expect(result).to include('type' => 'open_struct')
  end
end
