describe Crashbreak::SummaryFormatter do
  class SummaryTestFormatter < Crashbreak::SummaryFormatter
    def summary
      { example: 'true' }
    end
  end

  subject { SummaryTestFormatter.new }

  it 'wraps summary hash' do
    expect(subject.serialize).to eq(summary: subject.summary)
  end
end
