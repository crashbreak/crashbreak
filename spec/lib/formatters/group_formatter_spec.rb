describe Crashbreak::GroupFormatter do
  class GroupTestFormatter < Crashbreak::GroupFormatter
    group_name :example_group

    def group_hash
      { example: 'true' }
    end
  end

  subject { GroupTestFormatter.new }

  it 'wraps hash in additional_data and group_name key' do
    expect(subject.serialize).to eq(additional_data: { example_group:  subject.group_hash })
  end
end
