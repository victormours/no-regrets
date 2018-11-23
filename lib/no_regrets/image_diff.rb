require 'chunky_png'

class NoRegrets
  class ImageDiff

    def self.generate_diff(old_screenshot_path, new_screenshot_path, diff_path)
      images = [
        ChunkyPNG::Image.from_file(old_screenshot_path),
        ChunkyPNG::Image.from_file(new_screenshot_path)
      ]

      diff = []

      images.first.height.times do |y|
        images.first.row(y).each_with_index do |pixel, x|
          diff << [x,y] unless pixel == images.last[x,y]
        end
      end

      x, y = diff.map{ |xy| xy[0] }, diff.map{ |xy| xy[1] }

      images.last.rect(x.min, y.min, x.max, y.max, ChunkyPNG::Color.rgb(255,0,0))
      images.last.save(diff_path)
    end
  end

end
