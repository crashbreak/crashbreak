module Crashbreak
  class GithubIntegrationService
    def initialize(error_hash)
      @error_id = error_hash['id']
      @error_deploy_revision = error_hash['deploy_revision']
    end

    def push_test
      create_branch(branch_sha)
      create_test_file
    end

    def remove_test
      client.delete_contents(repo_name, file_path, "Remove test for error #{@error_id}",
                             test_file_sha, branch: "refs/#{error_branch_name}")
    end

    def create_pull_request
      client.create_pull_request(repo_name, development_branch_name, error_branch_name.gsub('heads/', ''), "Crashbreak - fix for error #{@error_id}", '')
    end

    private

    def branch_sha
      @branch_sha ||= begin
        if @error_deploy_revision
          client.commit(repo_name, @error_deploy_revision).sha rescue repo_sha
        else
          repo_sha
        end
      end
    end

    def repo_sha
      client.ref(repo_name, 'heads/master').object.sha
    end

    def test_file_sha
      @test_file_sha ||= client.contents(repo_name, path: file_path, ref: error_branch_name).sha
    end

    def create_branch(sha)
      client.create_ref repo_name, error_branch_name, sha
    end

    def create_test_file
      client.create_contents repo_name, file_path, "Add test file for error #{@error_id}",
                             file_content, { branch: "refs/#{error_branch_name}" }
    end

    def file_content
      test_file_content = File.read(Crashbreak.configurator.request_spec_template_path)
      test_file_content.gsub('<%= error_id %>', @error_id.to_s)
    end

    def client
      @client ||= Octokit::Client.new(login: Crashbreak.configure.github_login, password: Crashbreak.configure.github_password)
    end

    def repo_name
      Crashbreak.configure.github_repo_name
    end

    def error_branch_name
      "heads/crashbreak-error-#{@error_id}"
    end

    def file_path
      Crashbreak.configure.request_spec_file_path
    end

    def development_branch_name
      Crashbreak.configure.github_development_branch
    end
  end
end