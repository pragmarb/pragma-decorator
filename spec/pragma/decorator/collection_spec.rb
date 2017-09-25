# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Collection do
  subject { decorator }

  let(:decorator) { collection_decorator_klass.new(collection) }

  let(:instance_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      property :foo
    end
  end

  let(:collection_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      describe Pragma::Decorator::Collection
    end.tap do |klass|
      klass.send(:decorate_with, instance_decorator_klass)
    end
  end

  let(:collection) { [OpenStruct.new(foo: 'bar')] }

  let(:result) { JSON.parse(subject.to_json) }

  it 'renders the collection' do
    expect(result).to match('data' => [
      'foo' => 'bar'
    ])
  end
end
