module Jekyll
    module CustomHtmlMinifier
        require 'html_minifier'
        def self.minify_html(site)
            html_paths = Dir.glob("#{site.dest}/**/*.html")
            contents = html_paths.map {|p| IO.read(p)}
            contents.map! {|c| HtmlMinifier.minify(c, :collapseWhitespace => true, :conservativeCollapse => true, :removeComments => true)}
            for i in (0...html_paths.count)
                IO.write(html_paths[i], contents[i]) 
            end
        end
    end
    module JsMinifier
        require 'uglifier'
        def self.get_explicit_path(basepath, relative_path)
            if relative_path.start_with?(basepath)
                return relative_path
            end
            return "#{basepath}/#{relative_path}" 
        end
        def self.uglify(content)
            return Uglifier.compile(content)
        end
        
        # config in _config.yml
        def self.uglify_javascript(site, optimize)
            main_file = self.get_explicit_path(site.source, site.config['js_minifier']['main'])
            includes = site.config['js_minifier']['includes']
            includes.map! { |path| self.get_explicit_path(site.source, path)} 
            contents = []
            for inc in includes
                contents << IO.read(inc)
            end
            contents << IO.read(main_file)
            if optimize
                contents.map! { |c| Jekyll::JsMinifier::uglify(c)}
            end

            IO.write("#{site.dest}/js/main.js", contents.join(''))    
        end
    end
end

Jekyll::Hooks.register :site, :post_write do |site|
    if site.config['optimize_assets']
        Jekyll::CustomHtmlMinifier::minify_html(site)
    end
    Jekyll::JsMinifier::uglify_javascript(site, site.config['optimize_assets'])
end
