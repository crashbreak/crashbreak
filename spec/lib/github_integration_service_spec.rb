describe Crashbreak::GithubIntegrationService do
  subject { described_class.new error_id }

  let(:error_id) { 1 }
  let(:branch_name) { 'refs/heads/crashbreak-error-1' }
  let(:git_sha) { 'example_sha' }
  let(:file_content) { 'example_file_content' }

  let(:github_refs_url) { 'https://api.github.com/git/refs' }
  let(:github_master_ref_url) { "#{github_refs_url}/heads/master" }
  let(:github_create_content_url) { 'https://api.github.com/contents' }

  before(:each) do
    Crashbreak.configure.github_spec_file_path = 'spec/crashbreak_error_spec.rb'
  end

  it 'pushes test to github' do
    stub_request(:get, github_master_ref_url).to_return(body: DeepStruct.wrap(object: { sha: git_sha } ))

    stub_request(:post, github_refs_url).with(body: { ref: 'refs/heads/crashbreak-error-1', sha: git_sha}.to_json)

    stub_request(:put, "#{github_create_content_url}/#{Crashbreak.configure.github_spec_file_path}").
        with(body: { branch: branch_name, content: Base64.strict_encode64(file_content), message: 'Add test file for error 1' }.to_json)

    allow(subject).to receive(:file_content).and_return(file_content)

    subject.push_test
  end
end