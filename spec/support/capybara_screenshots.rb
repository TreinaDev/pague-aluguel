module NoFailedScreenshots
  def take_failed_screenshot; end
end

RSpec.configure do |config|
  config.include(NoFailedScreenshots)
end
