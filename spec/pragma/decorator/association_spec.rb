# frozen_string_literal: true
RSpec.describe Pragma::Decorator::Association do
  subject { decorator_klass.new(invoice) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Association
    end.tap do |klass|
      klass.send(:belongs_to, :customer, decorator: customer_decorator_klass)
    end
  end

  let(:customer_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Association

      property :id
      property :full_name
    end.tap do |klass|
      klass.send(:belongs_to, :company, decorator: company_decorator_klass)
    end
  end

  let(:company_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      property :id
      property :name
    end
  end

  let(:invoice) { OpenStruct.new(customer: customer) }
  let(:customer) { OpenStruct.new(id: 'customer_id', full_name: 'John Doe', company: company) }
  let(:company) { OpenStruct.new(id: 'company_id', name: 'ACME') }

  let(:result) { JSON.parse(subject.to_json(user_options: { expand: expand })) }
  let(:expand) { [] }

  context 'when the association is not expanded' do
    it "renders the associated object's ID" do
      expect(result).to eq('customer' => { 'id' => customer.id })
    end
  end

  context 'when the association is expanded' do
    let(:expand) { ['customer'] }

    it 'renders the associated object' do
      expect(result).to eq('customer' => {
        'id' => customer.id,
        'full_name' => customer.full_name,
        'company' => {
          'id' => company.id
        }
      })
    end
  end

  context 'when nested associations are expanded' do
    let(:expand) { ['customer', 'customer.company'] }

    it 'renders the associated objects' do
      expect(result).to eq('customer' => {
        'id' => customer.id,
        'full_name' => customer.full_name,
        'company' => {
          'id' => company.id,
          'name' => company.name
        }
      })
    end
  end
end
