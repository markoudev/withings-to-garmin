#!/usr/bin/env ruby

require 'json'
require 'faraday'
require 'tempfile'
require_relative 'utils'
require_relative 'garmin'

def headers
  {
    "Accept": "application/json",
    "Authorization": "Bearer #{app_config['withings_access_token']}"
  }
end

refresh_withings_access_token()

# Use the last_synced_measurement_at to only sync new activities, or default to 30 days ago
start_date = DateTime.parse(app_config['last_synced_measurement_at'] || (Date.today - 30).to_time.to_s).to_time

response = JSON.parse(Faraday.post(
  "https://wbsapi.withings.net/measure",
  {
    action: 'getmeas',
    meastypes: '1,6',
    startdate: (start_date + 1).to_i
  },
  headers
).body)

if response['body']['measuregrps'].count == 0
  puts "Nothing to do: no measurements returned"
  exit
end

# start CSV file with these lines
csv_lines = ["Body", "Date,Weight,BMI,Fat"]
last_measurement = nil

response['body']['measuregrps'].each do |group|
  # fat percentage is with 3 decimals
  fat_in_pct   = group['measures'].detect { |m| m['type'] == 6 }['value'].to_f / 1000
  weight_in_gr = group['measures'].detect { |m| m['type'] == 1 }['value']
  weight_in_kg = weight_in_gr.to_f / 1000
  bmi          = (weight_in_kg / 1.88 / 1.88).round(2)
  measure_date = Time.at(group['date'])

  last_measurement ||= measure_date
  last_measurement = [measure_date, last_measurement].max

  # in a very ugly way, append to array of csv lines
  csv_lines <<
    "\"#{measure_date.strftime("%Y-%m-%d")}\"," \
    "\"#{weight_in_kg}\"," \
    "\"#{bmi}\"," \
    "\"#{fat_in_pct}\""
end

# write contents to a temporary csv file, be sure to have it end with .csv or
# garmin will say it's unsupported
tempfile = Tempfile.new(['garmin', '.csv'])
tempfile << csv_lines.join("\n")
tempfile.flush
tempfile.close

puts "---"
puts "uploading csv file"
puts tempfile.path
puts File.read(tempfile.path)
puts "---"

upload_csv_to_garmin(tempfile.path)
store_last_synced_measurement_at(last_measurement)
