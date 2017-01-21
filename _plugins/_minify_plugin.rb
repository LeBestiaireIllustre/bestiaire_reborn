module Jekyll
    module JsMinifier
        require 'uglifier'
        def self.uglify(content)
            return Uglifier.compile(content)
        end
    end
end

Jekyll::Hooks.register :site, :post_write do |site|
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
