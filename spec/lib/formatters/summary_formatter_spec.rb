describe Crashbreak::SummaryFormatter do
  class SummaryTestFormatter < Crashbreak::SummaryFormatter
    def summary(exception)
      { example: 'true' }
    end
  end

  subject { SummaryTestFormatter.new }

  it 'wraps summary hash' do
    expect(subject.format(nil)).to eq(summary: subject.summary(nil))
  end
end
