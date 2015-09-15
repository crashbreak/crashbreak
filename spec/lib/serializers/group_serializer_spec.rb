describe Crashbreak::HashSerializer do
  class Crashbreak::TestHashSerialzier < Crashbreak::HashSerializer
    hash_name :example_group

    def hash_value
      { example: 'true' }
    end
  end

  subject { Crashbreak::TestHashSerialzier.new }

  it 'wraps hash in additional_data and group_name key' do
    expect(subject.serialize).to eq(additional_data: { example_group:  subject.hash_value })
  end
end
