#!/usr/bin/python2.7
import json
import urllib2
import subprocess

network = '074-605-6201'

opener = urllib2.build_opener()
opener.addheaders = [('User-Agent',
                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) ' +
                      'AppleWebKit/537.73.11 (KHTML, like Gecko) ' +
                      'Version/7.0.1 Safari/537.73.11')]

def fetch_profile():
    meta = json.load(opener.open(
        'https://m.meraki.com/ios/ng_lookup/' + network))
    return opener.open(meta['url']).read()

def main():
    if any(p.endswith('com.meraki.sm.mdm') for p in
           subprocess.check_output(['/usr/bin/profiles', '-L']).splitlines()):
        return
    print('Installing meraki_sm_mdm.mobileconfig')
    name = '/tmp/meraki_sm_mdm.mobileconfig'
    prof = fetch_profile()
    with open(name, 'wb') as f:
        f.write(fetch_profile())
    subprocess.call(['/usr/bin/profiles', '-I', '-F', name])

if __name__ == '__main__':
    main()
