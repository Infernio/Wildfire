#!/usr/bin/python3

import json
import math
import os
import shutil
import subprocess
import zipfile
from contextlib import suppress
from urllib.request import Request, urlopen

path_7z = None

def download_file(url: str, fpath: str):
    """Downloads a file from the specified URL to the specified path."""
    response = urlopen(url)
    block_sz = 8192
    with open(fpath, 'wb') as dl_file:
        while True:
            buff = response.read(block_sz)
            if not buff:
                break
            dl_file.write(buff)
    return os.path.abspath(fpath)

def download_github_release(owner: str, repo: str):
    """Downloads the latest GitHub release for the specified repository."""
    github_response = json.loads(urlopen(Request(
        'https://api.github.com/repos/%s/%s/releases' % (owner, repo),
         headers={'Accept': 'application/vnd.github.v3+json'},
    )).read())
    asset = github_response[0]['assets'][0]
    return download_file(asset['browser_download_url'], asset['name'])

def make_output(dir: str):
    """Creates a fresh version of the specified output directory. This
    recursively removes an existing directory at this path."""
    if '.tools' not in dir:
        raise RuntimeError('This script is not allowed to touch files outside '
                           '".tools", but attempted to delete %s' % dir)
    with suppress(FileNotFoundError):
        shutil.rmtree(dir)
    os.mkdir(dir)
    return os.path.abspath(dir)

def unpack_archive(src: str, dst: str):
    """Uses 7zip to unpack the specified source archive to the specified
    destination."""
    if src.endswith('.zip'):
        # For zip files, we can use Python's builtin zipfile
        with zipfile.ZipFile(src) as zfile:
            zfile.extractall(dst)
    else:
        # Otherwise, we have to use 7zip
        if not path_7z:
            raise RuntimeError('7zip not yet downloaded')
        cmd = u'"%s" x "%s" -y -bb1 -o"%s" -scsUTF-8 -sccUTF-8' % (
            path_7z, src, dst)
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, bufsize=1,
                                stdin=subprocess.PIPE)
        ret_code = proc.wait()
        if ret_code:
            raise RuntimeError('7zip returned error: %d' % ret_code)
    # In either case, clean up the now extracted archive
    os.remove(src)

def main():
    if not os.getcwd().endswith('.tools'):
        os.chdir('.tools')
        if not os.getcwd().endswith('.tools'):
            raise RuntimeError('This script must be run in the .tools folder '
                               'or in the directory above it.')
    print('Downloading 7zip...')
    src_7z = download_file('https://www.7-zip.org/a/7za920.zip', '7z.zip')
    dst_7z = mkdir_ok('7zip')
    unpack_archive(src_7z, dst_7z)
    global path_7z
    path_7z = dst_7z
    print('Downloading pyro...')
    src_pyro = download_github_release('fireundubh', 'pyro')
    dst_pyro = mkdir_ok('pyro')
    unpack_archive(src_pyro, dst_pyro)

if __name__ == '__main__':
    main()
