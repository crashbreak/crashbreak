describe Crashbreak::DeploysRepository do
  subject { described_class.new example_project_token, deploy_hash }

  let(:example_project_token) { 'fake_project_token' }
  let(:deploy_hash) { Hash[user: 'test_user@heroku.com', head: '0b5fb19', environment: 'production']}

  let!(:create_deploy_request) {
    stub_request(:post, "#{described_class::BASE_URL}/projects/#{example_project_token}/deploys").
        with(body: deploy_hash.to_json)
  }

  it 'sends request with deploy information' do
    subject.create
    expect(create_deploy_request).to have_been_made
  end
end