module Jekyll
    module CustomHtmlMinifier
        require 'html_minifier'
        def self.minify_html(site)
            html_paths = Dir.glob('_site/**/*.html')
            contents = html_paths.map {|p| IO.read(p)}
            contents.map! {|c| HtmlMinifier.minify(c, :collapseWhitespace => true, :collapseInlineTagWhitespace => true, :conservativeCollapse => true, :removeComments => true)}
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
end

Jekyll::Hooks.register :site, :post_write do |site|
    Jekyll::CustomHtmlMinifier::minify_html(site)
    Jekyll::JsMinifier::uglify_javascript(site)
end
