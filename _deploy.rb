#!/usr/bin/ruby
require 'fileutils'
BASE_URL = 'http://www.lebestiaireillustre.com'
BASE_PATH = '/home/chedy/blog_adel/bestiaire_reborn'
def abs_path(path)
    return "#{BASE_PATH}/#{path}"
end
def write_domain_name(config_file)
    content = IO.read config_file
    content.gsub! /^url: ""/, "url: #{BASE_URL}" 
    IO.write config_file, content
end

def remove_domain_name(config_file)
    content = IO.read config_file
    content.gsub! /^url: #{BASE_URL}/, 'url: ""'
    IO.write config_file, content
end

def remove_old_site(repo_path)
    old_files = Dir.glob(repo_path + '/**/*')
    for f in old_files
        if File.exist?(f)
            FileUtils.rm_r(f)
            puts "#{f} removed"
        end
    end
end

def copy_new_site(src, dest)
    copied = FileUtils.cp_r(Dir.glob(src + '/**'), dest)
    for f in copied
        puts "#{f} copied"
    end
end
begin
    write_domain_name(abs_path('_config.yml'))
    system('jekyll', 'clean', out: $stdout, err: :out)
    system('jekyll', 'build', out: $stdout, err: :out)
    remove_old_site(abs_path('_deployment/LeBestiaireIllustre.github.io'))
    copy_new_site(abs_path('_site'), abs_path('_deployment/LeBestiaireIllustre.github.io'))
    
    Dir.chdir abs_path('_deployment/LeBestiaireIllustre.github.io')
    system('git', 'add', '.', out: $stdout, err: :out)
    system('git', 'commit', '-m', "Deploy at #{Time.now.to_i}", out: $stdout, err: :out)
    system('git', 'push', 'origin', 'master', out: $stdout, err: :out)
ensure
    Dir.chdir BASE_PATH
    remove_domain_name(abs_path('_config.yml'))
end
