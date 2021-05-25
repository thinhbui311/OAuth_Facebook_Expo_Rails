
module Api::V1
  class AuthCallbacksController < ApplicationController
    include ActionController::MimeResponds

    def facebook
      raise "Missing authorize code in paramater" if params[:code].blank?

      basic_user_info, access_token = OauthProvider::Facebook.authenticate params[:code]

      if basic_user_info.blank? || access_token.blank?
        OauthProvider::Facebook.deauthorize access_token
        raise "Invalid user info"
      end
      format_response true, basic_user_info
    rescue => error
      format_response false, error
    end

    private

    def format_response status, response_data
      respond_to do |format|
        format.json do
          render(json: {
            status: status,
            response_data: response_data
          })
        end
      end
    end
  end
end
