module Engine
  class Screenshoter
    def self.screenshot(file)
      @scheduled_screenshot = file
    end

    def self.scheduled_screenshot
      @scheduled_screenshot
    end

    def self.take_screenshot
      file = @scheduled_screenshot
      FileUtils.mkdir_p(File.dirname(file))

      @scheduled_screenshot = nil
      width = Engine.screen_width
      height = Engine.screen_height
      pixels = ' ' * (width * height * 3)
      GL.ReadPixels(0, 0, width, height, GL::RGB, GL::UNSIGNED_BYTE, pixels)
      png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
      pixels = pixels.bytes.map { |b| b.to_i }
      x = 0
      y = 0
      pixels.each_slice(3) do |r, g, b|
        png[x, height - y - 1] = ChunkyPNG::Color.rgb(r, g, b)
        x += 1
        if x >= width
          x = 0
          y += 1
        end
      end
      png.save(file)
    end
  end
end