require "httparty"

module OauthProvider
  class Facebook
    include HTTParty

    base_uri "https://graph.facebook.com/v10.0"

    def self.authenticate code
      provider = self.new
      access_token = provider.get_access_token code
      user_info = provider.get_user_profile access_token
      return user_info, access_token
    end

    def self.deauthorize access_token
      options = { query: { access_token: access_token } }
      response = self.delete("/me/permissions", options)

      unless response.success?
        Rails.logger.error "OauthProvider::Facebook.deauthorize Failed"
        fail OauthProvider::ResponseError, "errors.auth.facebook.deauthorization"
      end
      response.parsed_response
    end

    def get_access_token code
      response = self.class.get("/oauth/access_token", query(code))

      unless response.success?
        Rails.logger.error "OauthProvider::Facebook.get_access_token Failed"
        fail OauthProvider::ResponseError, "errors.auth.facebook.access_token"
      end
      response.parsed_response["access_token"]
    end

    def get_user_profile access_token
      options = { query: { access_token: access_token } }
      response = self.class.get("/me", options)

      unless response.success?
        Rails.logger.error "OauthProvider::Facebook.get_user_profile Failed"
        fail OauthProvider::ResponseError, "errors.auth.facebook.user_profile"
      end
      response.parsed_response
    end

    private

    def query code
      {
        query: {
          code: code,
          redirect_uri: "http://localhost:19006/",
          client_id: "1703247659862136",
          client_secret: "f5114a4d99f423d33cc478d7914502c5"
        }
      }
    end
  end
end
