# spec/support/screenshot_matcher.rb

require "fileutils"

RSpec::Matchers.define :match_screenshot_on_disk do |expected|
  match do |actual_image|
    if ENV["UPDATE_SCREENSHOTS"]
      actual_image.save(expected)
      return true
    end

    expected_image = ChunkyPNG::Image.from_file(expected)

    return false unless actual_image.width == expected_image.width && actual_image.height == expected_image.height

    diff_image = ChunkyPNG::Image.new(actual_image.width, actual_image.height, ChunkyPNG::Color::TRANSPARENT)

    failed = false
    actual_image.height.times do |y|
      actual_image.row(y).each_with_index do |pixel, x|
        if pixel == expected_image[x, y]
          diff_image[x, y] = pixel
        else
          diff_image[x, y] = ChunkyPNG::Color.rgb(255, 0, 0)
        end
        failed ||= pixel != expected_image[x, y]
      end
    end

    if failed
      diff_location = File.join(File.dirname(expected), "temp", "diff_#{File.basename(expected)}")
      FileUtils.mkdir_p(File.dirname(diff_location))
      File.delete(diff_location) if File.exist?(diff_location)
      diff_image.save(diff_location)

      actual_location = File.join(File.dirname(expected), "temp", "actual_#{File.basename(expected)}")
      FileUtils.mkdir_p(File.dirname(actual_location))
      File.delete(actual_location) if File.exist?(actual_location)
      actual_image.save(actual_location)
    end
    !failed
  end

  failure_message do |actual|
    "expected that image would match #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected that image would not match #{expected}"
  end
end