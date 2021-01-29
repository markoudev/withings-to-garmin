require 'yaml'

def app_config
  YAML.load_file('configuration.yml')
end

def update_config_with(hash)
  File.write('configuration.yml', YAML.dump(app_config.merge(hash)))
end

def store_withings_credentials(access_token, refresh_token)
  update_config_with({
    'withings_access_token' => access_token,
    'withings_refresh_token' => refresh_token
  })
end

def store_last_synced_measurement_at(time)
  update_config_with({
    'last_synced_measurement_at' => time.to_s
  })
end

def refresh_withings_access_token
  puts "refreshing withings access token"

  url = "https://wbsapi.withings.net/v2/oauth2" \
    "?action=requesttoken" \
    "&grant_type=refresh_token" \
    "&refresh_token=#{app_config['withings_refresh_token']}" \
    "&client_id=#{app_config['withings_client_id']}" \
    "&client_secret=#{app_config['withings_client_secret']}" \
    "&redirect_uri=#{app_config['withings_callback_url']}"

  response = JSON.parse(Faraday.post(url).body)
  access_token = response['body']['access_token']
  refresh_token = response['body']['refresh_token']

  puts "new tokens acquired"

  store_withings_credentials(access_token, refresh_token)
end
