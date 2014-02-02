#!/usr/bin/python2.7
import shutil
import urllib2
import subprocess

opener = urllib2.build_opener()
opener.addheaders = [('User-Agent',
                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) ' +
                      'AppleWebKit/537.73.11 (KHTML, like Gecko) ' +
                      'Version/7.0.1 Safari/537.73.11')]

def install_agent():
    if ('com.meraki.pkg.MerakiAgent' in
        subprocess.check_output(['/usr/sbin/pkgutil', '--pkgs']).splitlines()):
        return
    print('Installing MerakiPCCAgent.pkg')
    pkg = '/tmp/MerakiPCCAgent.pkg'
    with open(pkg, 'wb') as f:
        shutil.copyfileobj(
            opener.open(
                'http://n74.meraki.com/ci-downloads/' +
                '14519cbbfb3f92927490a49eba1f0345c52c9fc0/MerakiPCCAgent.pkg'),
            f)
    subprocess.call(['/usr/sbin/installer', '-pkg', pkg, '-target', '/'])

def main():
    install_agent()

if __name__ == '__main__':
    main()
