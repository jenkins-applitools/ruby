require 'eyes_selenium'

describe 'Testing Applitools' do
  
  before(:all) do
    @eyes = Applitools::Selenium::Eyes.new
    @eyes.api_key = ENV['APPLITOOLS_API_KEY']
    #@eyes.force_full_page_screenshot = true
    #@eyes.stitch_mode = :css
    
    # @eyes.branch_name = 'jenkins-applitools/ruby/test2'
    # @eyes.parent_branch_name = 'jenkins-applitools/ruby/master'
    
    batch_info = Applitools::BatchInfo.new(nil)
    batch_info.id = ENV['APPLITOOLS_BATCH_ID']
    @eyes.batch = batch_info
    
    
    caps = Selenium::WebDriver::Remote::Capabilities.chrome()
    caps['platform'] = 'Windows 7'
    caps['version'] = '63.0'
    caps['screenResolution'] = '2560x1600'    
    sauce_user = ENV['SAUCE_USER']
    sauce_key = ENV['SAUCE_KEY']
    @driver = Selenium::WebDriver.for(:remote, url: "https://#{sauce_user}:#{sauce_key}@ondemand.saucelabs.com:443/wd/hub", desired_capabilities: caps)
  end
  
  after(:all) do
    @eyes.abort_if_not_closed
    @driver.quit
  end

  it 'Applitools Test' do |e|
    @eyes.open(driver: @driver, app_name: "Branch Testing", test_name: e.full_description, viewport_size: {width: 1050, height: 750})
    @driver.get 'https://google.it'
    @eyes.check_window 'Google Italy 10'
    results = @eyes.close(false)
    #expect(results).not_to be_nil
    expect(results.passed?).to eq true
  end
end
