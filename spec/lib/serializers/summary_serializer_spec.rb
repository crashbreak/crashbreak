describe Crashbreak::SummarySerializer do
  class Crashbreak::SummaryTestSerializer < Crashbreak::SummarySerializer
    def summary
      { example: 'true' }
    end
  end

  subject { Crashbreak::SummaryTestSerializer.new }

  it 'wraps summary hash' do
    expect(subject.serialize).to eq(summary: subject.summary)
  end
end
