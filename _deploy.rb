#!/usr/bin/ruby

BASE_URL = 'http://www.lebestiaireillustre.com'

def write_domain_name()
    content = IO.read '_config.yml'
    content.gsub! /^url: ""/, "url: #{BASE_URL}" 
    IO.write '_config.yml', content
end

def remove_domain_name()
    content = IO.read '_config.yml'
    content.gsub! /^url: #{BASE_URL}/, 'url: ""'
    IO.write '_config.yml', content
end

begin
    write_domain_name()
    system('jekyll', 'clean', out: $stdout, err: :out)
    system('jekyll', 'build', out: $stdout, err: :out)
    system('rm', '-rvf', '../LeBestiaireIllustre.github.io/*', out: $stdout, err: :out)
    puts %x[cp -Rvf _site/* ../LeBestiaireIllustre.github.io]
    Dir.chdir '../LeBestiaireIllustre.github.io'
    system('git', 'add', '.', out: $stdout, err: :out)
    system('git', 'commit', '-m', "Deploy at #{Time.now.to_i}", out: $stdout, err: :out)
    system('git', 'push', 'origin', 'master', out: $stdout, err: :out)
ensure
    Dir.chdir '../bestiaire_reborn'
    remove_domain_name()
end
