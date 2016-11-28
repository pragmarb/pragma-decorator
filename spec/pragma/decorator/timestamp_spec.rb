# frozen_string_literal: true
RSpec.describe Pragma::Decorator::Timestamp do
  subject { decorator_klass.new(model) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      feature Pragma::Decorator::Timestamp
      timestamp :created_at
    end
  end

  let(:model) { OpenStruct.new(created_at: Time.utc(1970, 'jan', 1, 1, 0, 0)) }

  let(:result) { JSON.parse(subject.to_json) }

  it 'converts the timestamp to UNIX time' do
    expect(result).to include('created_at' => 3600)
  end
end
