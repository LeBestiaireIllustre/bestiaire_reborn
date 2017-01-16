module Jekyll
  
  module UrlFriendlyFilter
    def self.to_url_friendly(tagname)
      return tagname.gsub(' ', '_')
    end
    def to_url(tagname)
        return UrlFriendlyFilter::to_url_friendly(tagname) 
    end
  end
  
  module GridifyFilter
    require 'ostruct'
    def self.get_column_size(content)
        column_size = 3

        if content.length >= 24
            column_size = 6
        end

        if content.length >= 44
            column_size = 9
        end
        
        if content.length >= 60
            column_size = 12
        end

        return column_size
    end
    def self.take(tags)
        result = []
        counter = 0
        while (tags.length > 0) and (counter < 12) and (result.length < 4) do
            tag = tags.shift
            counter += GridifyFilter::get_column_size(tag[0])
            tag.push(GridifyFilter::get_column_size(tag[0]))
            result.push(tag)
        end
        return result
    end
    def gridify(input)
        result = []
        while input.length > 0 do
            result.push(GridifyFilter::take(input))
        end
        return result
    end
  end
      
  class TagIndex < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_page.html')
      self.data['tag'] = tag
      tag_title_prefix = site.config['tag_title_prefix'] || 'Posts Tagged '
      tag_title_suffix = site.config['tag_title_suffix'] || ''
      self.data['title'] = "#{tag_title_prefix}#{tag}#{tag_title_suffix}"
    end
  end
  
  class TagGenerator < Generator
    safe true
    def generate(site)
      if site.layouts.key? 'tag_page'
        dir = site.config['tag_dir'] || 'tags'
        site.tags.keys.each do |tag|
          write_tag_index(site, File.join(dir, Jekyll::UrlFriendlyFilter::to_url_friendly(tag)), tag)
        end
      end
    end
    
    def write_tag_index(site, dir, tag)
      index = TagIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.pages << index
    end

  end

end

Liquid::Template.register_filter(Jekyll::UrlFriendlyFilter)
Liquid::Template.register_filter(Jekyll::GridifyFilter)
