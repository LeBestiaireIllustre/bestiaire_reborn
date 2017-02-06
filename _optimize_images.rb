#!/usr/bin/ruby
module ImageCompress 
    require 'image_optimizer'
    require 'fastimage_resize'

    def self.get_height(size, width)
        if self.portrait?(size)
            ratio = size[0] / size[1]
            return width * ratio
        else
            ratio = size[1] / size[0]
            return width * ratio
        end
    end
    def self.portrait?(size)
        # width < height
        return size[0] < size[1]
    end
    def self.resize?(image_path)
        return (image_path.include?('assets/') or image_path.include?('images/bestiaire'))
    end
    def self.resize(image)
        target_width = 520
        size = FastImage.size(image)
        if (size[0] > target_width) and (self.resize?(image))
            FastImage.resize(image, target_width, self.get_height(size, target_width), :outfile => image)
        end
    end
    
    def self.optimize()
        images = Dir.glob('./**/*.jpg')
        images.push(*(Dir.glob('./**/*.png')))
        images.reject! { |img| img.include?('_assets')}
        images.reject! { |img| img.include?('_images')}
        images.reject! { |img| img.include?('_site')}
        for image in images
            self.resize(image)
            ImageOptimizer.new(image, quality: 65, level: 9).optimize 
        end
    end
end

ImageCompress::optimize()
