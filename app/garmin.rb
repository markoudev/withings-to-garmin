require 'selenium-webdriver'

def upload_csv_to_garmin(path)
  puts "Uploading #{path}"

  # configure the driver to run in headless mode
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for(:chrome, options: options)
  wait = Selenium::WebDriver::Wait.new(timeout: 10)

  driver.manage.window.resize_to(1600, 900)

  puts "Signing in..."
  driver.navigate.to("https://connect.garmin.com/signin/")

  wait.until do
    sleep 3
    driver.find_element(id: "gauth-widget-frame-gauth-widget")
  end

  driver.switch_to.frame("gauth-widget-frame-gauth-widget")

  puts "Switched to frame, entering credentials"

  wait.until { driver.find_element(id: "username") }.send_keys(app_config['garmin_username'])
  wait.until { driver.find_element(id: "password") }.send_keys(app_config['garmin_password'])

  driver.find_element(id: "login-btn-signin").click

  puts "Logging in"

  sleep 3
  driver.navigate.to("https://connect.garmin.com/modern/import-data")
  # driver.save_screenshot("garmin.1.import-data.png")

  puts "Going to import data"

  sleep 3
  driver.find_element(css: "input[type=file]").send_keys(path)
  # driver.save_screenshot("garmin.2.file-selected.png")

  puts "File selected"

  sleep 2
  driver.find_element(id: "import-data-start").click()
  # driver.save_screenshot("garmin.3.import-started.png")

  puts "Import started"

  sleep 2
  driver.find_element(xpath: "//a[contains(@class, 'btn')][contains(text(), 'Continue')]").click()

  puts "Import confirmed"

  sleep 5

  puts "File uploaded (hopefully)"

  # driver.save_screenshot("garmin.png")
end
