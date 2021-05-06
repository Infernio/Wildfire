#!/usr/bin/python3

# Builds a new release of Wildfire by compiling scripts, packing a BSA and
# compressing the result into a versioned 7z archive.

import os
import shutil
import subprocess
import tempfile

# The version that Wildfire currently has.
WF_VERSION = '0.1'
# Folders of assets used by Wildfire that need to be in the release BSA.
BSA_DIRS = ['interface', 'scripts', 'textures']

def run_command(exe: str, args: list[str]):
    """Runs the specified executable with the specified arguments. Handles
    spaces in paths correctly."""
    cmd = '"%s"' % exe
    for arg in args:
        cmd += ' '
        if ' ' in arg:
            cmd += '"%s"' % arg
        else:
            cmd += arg
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, bufsize=1,
                            stdin=subprocess.PIPE, encoding='utf-8')
    with proc.stdout as out:
        for line in out.readlines():
            print(line.strip())
    err_code = proc.wait()
    if err_code:
        raise RuntimeError('Subprocess returned error: %d' % err_code)

def section(msg: str, trail_newline=True):
    """Prints a 'section' to stdout."""
    print()
    print('===== %s =====' % msg)
    if trail_newline: print()

def main():
    if not os.getcwd().endswith('.scripts'):
        try:
            os.chdir('.scripts')
        except OSError as e:
            raise RuntimeError('This script must be run in the .scripts '
                               'folder or in the directory above it.') from e
    # The Wildfire root directory - where Wildfire.esp sits
    wf_root = os.path.dirname(os.getcwd())
    section('Building Wildfire v%s' % WF_VERSION, trail_newline=False)
    section('Compiling scripts with pyro')
    exe_pyro = os.path.abspath(os.path.join('pyro', 'pyro.exe'))
    wf_ppj = os.path.join(wf_root, 'Wildfire.ppj')
    run_command(exe_pyro, [wf_ppj])
    section('Packing with BSArch', trail_newline=False)
    # We need a temp dir for BSArch with only the assets we want in the BSA
    tmp_dir = tempfile.mkdtemp(prefix='wildfire_')
    for asset_dir in BSA_DIRS:
        shutil.copytree(os.path.join(wf_root, asset_dir),
                        os.path.join(tmp_dir, asset_dir))
    exe_bsarch = os.path.abspath(os.path.join('pyro', 'tools', 'bsarch.exe'))
    wf_bsa = os.path.join(wf_root, 'Wildfire.bsa')
    run_command(exe_bsarch, ['pack', tmp_dir, wf_bsa, '-sse', '-z'])
    section('Packaging with 7zip')
    exe_7z = os.path.join('7zip', '7za.exe')
    wf_esp = os.path.join(wf_root, 'Wildfire.esp')
    # Where to put the Wildfire archive (Bash Installers/Wildfire vX.y.7z)
    wf_archive = os.path.join(os.path.dirname(wf_root),
                              'Wildfire v%s.7z' % WF_VERSION)
    run_command(exe_7z, ['a', wf_archive, wf_bsa, wf_esp])
    section('Build succeeded')
    # Clean up the temp dir
    shutil.rmtree(tmp_dir)

if __name__ == '__main__':
    main()
