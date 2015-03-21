describe 'error id: <%= error_id %>', type: :request do

  let(:restorers_data) { StateRestorer.new('<%= error_id %>').restore }
  let(:request) { restorers_data[:request] }

  it 'sends request' do
    get request['PATH_INFO']
  end
end
