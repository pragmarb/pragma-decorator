# frozen_string_literal: true
RSpec.describe Pragma::Decorator::Association do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Association
    end.tap do |klass|
      klass.send(:belongs_to, :author, decorator: associated_decorator_klass)
    end
  end

  let(:associated_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      property :id
      property :name
    end
  end

  let(:model) do
    OpenStruct.new(author: associated_model)
  end

  let(:associated_model) do
    OpenStruct.new(id: 'author_id', name: 'John Doe')
  end

  context 'when the association is not expanded' do
    let(:result) { JSON.parse(subject.to_json) }

    it "renders the associated object's ID" do
      expect(result).to eq('author' => { 'id' => associated_model.id })
    end
  end

  context 'when the association is expanded' do
    let(:result) { JSON.parse(subject.to_json(user_options: { expand: ['author'] })) }

    it 'renders the associated object' do
      expect(result).to eq('author' => {
        'id' => associated_model.id,
        'name' => associated_model.name
      })
    end
  end
end
