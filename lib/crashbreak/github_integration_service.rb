module Crashbreak
  class GithubIntegrationService
    def initialize(error_id)
      @error_id = error_id
    end

    def push_test
      create_branch(branch_sha)
      create_test_file
    end

    private

    def branch_sha
      get_sha.object.sha
    end

    def get_sha
      client.ref repo_name, 'heads/master'
    end

    def create_branch(sha)
      client.create_ref repo_name, error_branch_name, sha
    end

    def create_test_file
      client.create_contents repo_name, Crashbreak.configure.github_spec_file_path, "Add test file for error #{@error_id}",
                             file_content, { branch: "refs/#{error_branch_name}" }
    end

    def file_content
      test_file_content = File.read("#{Crashbreak.root}/lib/generators/crashbreak/templates/test.rb")
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
  end
end