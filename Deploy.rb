#!/usr/bin/ruby
module Deploy
    require 'fileutils'
    BASE_URL = 'http://www.lebestiaireillustre.com'
    BASE_PATH = File.expand_path(File.dirname(__FILE__))
    def self.abs_path(path)
        return "#{BASE_PATH}/#{path}"
    end
    def self.write_domain_name(config_file)
        content = IO.read config_file
        content.gsub! /^url: ""/, "url: #{BASE_URL}" 
        IO.write config_file, content
    end

    def self.remove_domain_name(config_file)
        content = IO.read config_file
        content.gsub! /^url: #{BASE_URL}/, 'url: ""'
        IO.write config_file, content
    end

    def self.remove_old_site(repo_path)
        old_files = Dir.glob(repo_path + '/**/*')
        for f in old_files
            if File.exist?(f)
                FileUtils.rm_r(f)
                puts "#{f} removed"
            end
        end
    end

    def self.copy_new_site(src, dest)
        copied = FileUtils.cp_r(Dir.glob(src + '/**'), dest)
        for f in copied
            puts "#{f} copied"
        end
    end
    def self.deploy 
        begin
            Dir.chdir BASE_PATH
            self.write_domain_name(self.abs_path('_config.yml'))
            system('jekyll', 'clean', out: $stdout, err: :out)
            system('jekyll', 'build', out: $stdout, err: :out)
            puts('STEP 2')
            self.remove_old_site(self.abs_path('_deployment/LeBestiaireIllustre.github.io'))
            self.copy_new_site(self.abs_path('_site'), self.abs_path('_deployment/LeBestiaireIllustre.github.io'))
            puts('STEP 3')
            Dir.chdir abs_path('_deployment/LeBestiaireIllustre.github.io')
            system('git', 'add', '.', out: $stdout, err: :out)
            system('git', 'commit', '-m', "Deploy at #{Time.now.to_i}", out: $stdout, err: :out)
            puts('STEP 4')
            system('git', 'push', 'origin', 'master', '--force', out: $stdout, err: :out)
            puts('STEP 5')
        ensure
            Dir.chdir BASE_PATH
            self.remove_domain_name(self.abs_path('_config.yml'))
            puts('STEP 6')
        end
    end
end

if __FILE__ == $0
    Deploy::deploy()
end
