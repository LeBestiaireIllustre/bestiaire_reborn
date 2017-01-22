module Jekyll
    module CustomHtmlMinifier
        require 'html_press'
        def self.minify_html(site)
            html_paths = %x[find _site/ -iname '*.html'].split("\n")
            contents = html_paths.map {|p| IO.read(p)}
            contents.map! {|c| HtmlPress.press(c)}
            for i in (0...html_paths.count)
                IO.write(html_paths[i], contents[i]) 
            end
        end
    end
    module JsMinifier
        require 'uglifier'
        def self.uglify(content)
            return Uglifier.compile(content)
        end
        
        # config in _config.yml
        def self.uglify_javascript(site)
            main_file = site.config['js_minifier']['main']
            includes = site.config['js_minifier']['includes']
            contents = []
            for inc in includes
                contents << IO.read(inc)
            end
            contents << IO.read(main_file)
            contents.map! { |c| Jekyll::JsMinifier::uglify(c)}

            IO.write('_site/js/main.js', contents.join(''))    
        end
    end
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
        
        def self.optimize(site)
            images = %x[find _site/ -iname '*.jpg'].split("\n")
            images.push(*(%x[find _site/ -iname '*.png'].split("\n")))
            for image in images
                self.resize(image)
                ImageOptimizer.new(image).optimize 
            end
        end
    end
end

Jekyll::Hooks.register :site, :post_write do |site|
    Jekyll::CustomHtmlMinifier::minify_html(site)
    Jekyll::JsMinifier::uglify_javascript(site)
end
