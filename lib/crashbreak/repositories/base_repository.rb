module Crashbreak
  class BaseRepository
    BASE_URL = 'https://crashbreak.herokuapp.com/api'

    def project_token
      Crashbreak.configure.api_key
    end
  end
end