describe Crashbreak::GithubIntegrationService do
  subject { described_class.new error_hash }

  let(:error_hash) { Hash['id' => 1, 'deploy_revision' => 'example_deploy_revision'] }
  let(:branch_name) { 'refs/heads/crashbreak-error-1' }
  let(:git_sha) { 'example_sha' }
  let(:file_content) { 'example_file_content' }

  let(:github_refs_url) { 'https://api.github.com/repos/user/repo/git/refs' }
  let(:github_master_ref_url) { "#{github_refs_url}/heads/master" }
  let(:github_create_content_url) { 'https://api.github.com/repos/user/repo/contents' }
  let(:github_test_file_url) { 'https://api.github.com/repos/user/repo/contents/spec/crashbreak_error_spec.rb' }
  let(:github_pull_requests_url) { 'https://api.github.com/repos/user/repo/pulls' }
  let(:github_deploy_commit_url) { 'https://api.github.com/repos/user/repo/commits/example_deploy_revision' }

  before(:each) do
    Crashbreak.configure.github_spec_file_path = 'spec/crashbreak_error_spec.rb'
    allow_any_instance_of(WebMock::Response).to receive(:assert_valid_body!).and_return(true)
  end

  it 'pushes test to github' do
    stub_request(:get, github_master_ref_url).to_return(body: DeepStruct.wrap(object: { sha: git_sha } ))

    stub_request(:get, github_deploy_commit_url).to_return(body: DeepStruct.wrap(sha: 'example_deploy_revision'))

    stub_request(:post, github_refs_url).with(body: { ref: 'refs/heads/crashbreak-error-1', sha: 'example_deploy_revision'}.to_json)

    stub_request(:put, "#{github_create_content_url}/#{Crashbreak.configure.github_spec_file_path}").
        with(body: { branch: branch_name, content: Base64.strict_encode64(file_content), message: 'Add test file for error 1' }.to_json)

    allow(subject).to receive(:file_content).and_return(file_content)

    subject.push_test
  end

  it 'removes test from github' do
    stub_request(:get, "#{github_test_file_url}?ref=heads/crashbreak-error-1").to_return(body: DeepStruct.wrap(sha: git_sha))

    stub_request(:delete, github_test_file_url).
        with(body: { branch: 'refs/heads/crashbreak-error-1', message: 'Remove test for error 1', sha: git_sha }.to_json)

    subject.remove_test
  end

  it 'creates pull request' do
    stub_request(:post, github_pull_requests_url).
        with(body: { base: 'master', head: 'crashbreak-error-1', title: 'Crashbreak - fix for error 1', body: '' }.to_json)

    subject.create_pull_request
  end
end