describe Crashbreak::HashFormatter do
  class TestHashFormatter < Crashbreak::HashFormatter
    hash_name :example_group

    def hash_value
      { example: 'true' }
    end
  end

  subject { TestHashFormatter.new }

  it 'wraps hash in additional_data and group_name key' do
    expect(subject.serialize).to eq(additional_data: { example_group:  subject.hash_value })
  end
end
