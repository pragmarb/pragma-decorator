# frozen_string_literal: true
RSpec.describe Pragma::Decorator::Base do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(described_class) do
      property :title
    end
  end

  let(:model) { OpenStruct.new(title: 'Wonderful World') }

  let(:result) { JSON.parse(subject.to_json) }

  it 'instantiates correctly' do
    expect { subject }.not_to raise_error
  end

  it 'renders JSON' do
    expect(result).to include('title' => 'Wonderful World')
  end
end
