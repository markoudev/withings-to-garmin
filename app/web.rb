require 'sinatra'
require 'yaml'
require 'faraday'
require 'securerandom'
require_relative 'utils'

set :bind, '0.0.0.0'

not_found do
  erb :not_found
end

get '/' do
  erb :index
end

get '/withings-auth' do
  redirect "https://account.withings.com/oauth2_user/authorize2" \
    "?response_type=code" \
    "&client_id=#{app_config['withings_client_id']}" \
    "&state=#{SecureRandom.hex}" \
    "&scope=user.metrics" \
    "&redirect_uri=#{app_config['withings_callback_url']}"
end

get '/withings-callback' do
  url = "https://wbsapi.withings.net/v2/oauth2" \
    "?action=requesttoken" \
    "&grant_type=authorization_code" \
    "&code=#{params['code']}" \
    "&client_id=#{app_config['withings_client_id']}" \
    "&client_secret=#{app_config['withings_client_secret']}" \
    "&redirect_uri=#{app_config['withings_callback_url']}"

  response = JSON.parse(Faraday.post(url).body)
  access_token = response['body']['access_token']
  refresh_token = response['body']['refresh_token']

  store_withings_credentials(access_token, refresh_token)
  redirect '/'
end
