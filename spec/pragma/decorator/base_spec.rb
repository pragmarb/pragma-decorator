RSpec.describe Pragma::Decorator::Base do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(described_class) do
      property :title
    end
  end

  let(:model) { OpenStruct.new(title: 'Wonderful World') }

  it 'instantiates correctly' do
    expect { subject }.not_to raise_error
  end

  it 'renders JSON' do
    expect(JSON.parse(subject.to_json)).to eq('title' => 'Wonderful World')
  end
end
