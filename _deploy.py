#!/usr/bin/python3
import os
import re
import time
import jsmin
import subprocess
BASE_URL = 'http://www.lebestiaireillustre.com'

def write_domain_name():
    with open('_config.yml') as f:
        content = f.read()
    
    content = re.sub(r'url: ""', 'url: "{0}"'.format(BASE_URL), content)
    
    with open('_config.yml', 'w') as f:
        f.write(content)

def remove_domain_name():
    with open('_config.yml') as f:
        content = f.read()
    
    content = re.sub(r'url: "{0}"'.format(BASE_URL), 'url: ""', content)
    
    with open('_config.yml', 'w') as f:
        f.write(content)

try:
    write_domain_name()
    subprocess.run(['jekyll', 'clean'])
    subprocess.run(['jekyll', 'build'])
    subprocess.run('rm -rvf ../LeBestiaireIllustre.github.io/*', shell=True)
    subprocess.run('cp -Rvf ./_site/* ../LeBestiaireIllustre.github.io/', shell=True)
    os.chdir('../LeBestiaireIllustre.github.io')
    subprocess.run(['git', 'add', '.'])
    subprocess.run(['git', 'commit', '-m', '"Deploy at {0}"'.format(time.time())])
    subprocess.run(['git', 'push', 'origin', 'master'])
finally:
    os.chdir('../bestiaire_reborn')
    remove_domain_name()
