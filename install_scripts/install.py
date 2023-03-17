#!/usr/bin/python3
# Usage: python3 install.py packages.json

import json
import os
import subprocess
import sys


def Info(*args, **kwargs):
  print(*args, **kwargs)


def Error(*args, **kwargs):
  print(*args, **kwargs)


class Installer:
  pass


class AptInstaller(Installer):
  def __init__(self, config):
    pass

  def Install(self, package_config):
    pkg = package_config['package']
    Info("==========Installing %s==============" % pkg)
    result = subprocess.run(
        ['dpkg-query', '-W', "-f=${Version}", pkg], capture_output=True)
    if result.returncode == 0:
      Info(pkg, 'already installed. Installed version:', result.stdout)
    else:
      repo = package_config.get('repo', '')
      if repo:
        subprocess.check_call(['sudo', 'glinux-add-repo', repo])
        subprocess.check_call(['sudo', 'apt', 'update'])
      subprocess.check_call(['sudo', 'apt', 'install', pkg])


class BrewInstaller(Installer):
  def __init__(self, config):
    pass

  def Install(self, package_config):
    pkg = package_config['package']
    Info("==========Installing %s==============" % pkg)
    output = subprocess.check_output(['brew', 'info', '--json=v2', pkg])
    json_output = json.loads(output)
    installed = (
        (json_output["formulae"] or json_output["casks"])[0]["installed"])
    if installed:
      if isinstance(installed, list):
        versions = ', '.join(v['version'] for v in installed)
      else:
        versions = installed
      Info(pkg, 'already installed. Installed versions:', versions)
    else:
      cmd = ['brew', 'install', pkg]
      subprocess.check_output(cmd)


class GitInstaller(Installer):
  def __init__(self, config):
    pass

  def Install(self, package_config):
    repo = package_config['repo']
    dir = os.path.expanduser(package_config['dir'])
    Info("==========git clone %s %s==============" % (repo, dir))
    if os.path.exists(dir) and os.listdir(dir):
      Info("Directory is non-empty. Running git update instead.")
      subprocess.check_output(['git', '--git-dir=%s/.git' % dir, 'pull'])
    else:
      subprocess.check_output(['git', 'clone', repo, dir])


class SymlinkInstaller(Installer):
  def __init__(self, config):
    self.src_root = config['src_root']
    self.dest_root = config['dest_root']
    self.backup_dir = config['backup_dir']

  def Install(self, package_config):
    src = os.path.expanduser(os.path.join(
        self.src_root, package_config['src']))
    dest = os.path.expanduser(os.path.join(
        self.dest_root, package_config['dest']))
    Info("==========symlink: %s -> %s==============" % (src, dest))
    if not os.path.exists(src):
      Error("Failed:", src, "does not exist!")
      return
    if os.path.exists(dest):
      if os.path.samefile(src, dest):
        Info("Symlink already exists.")
        return
      else:
        Info("Moving %s to: %s" % (dest, self.backup_dir))
        os.renames(dest, os.path.join(self.backup_dir, os.path.basename(dest)))
    if os.path.lexists(dest):
      # Remove broken symlink.
      # For a broken symlink, exists() returns False and lexists() returns False.
      os.remove(dest)
    if not os.path.exists(os.path.dirname(dest)):
      os.makedirs(os.path.dirname(dest))
    os.symlink(src, dest)


class CmdInstaller(Installer):
  def __init__(self, config):
    pass

  def Install(self, package_config):
    cmd = package_config['cmd']
    Info("==========Running: %s ==============" % cmd)
    components = cmd.split()
    subprocess.check_output(
        [os.path.expanduser(components[0])] + components[1:])


def GetInstaller(name, config):
  installers = {
      'apt': AptInstaller,
      'brew': BrewInstaller,
      'symlink': SymlinkInstaller,
      'cmd': CmdInstaller,
      'git': GitInstaller
  }
  if name not in installers:
    return None
  tool_config = None
  if config and name in config:
    tool_config = config.get(name)
  return installers[name](tool_config)


def InstallAll(config):
  for tool, packages in config.get("packages", {}).items():
    installer = GetInstaller(tool, config.get("tools"))
    if installer:
      for package in packages:
        installer.Install(package)
    else:
      raise Exception("Unsupported tool:", tool,
                      "packages not installed:", packages)


if __name__ == '__main__':
  if len(sys.argv) < 2:
    Error("Usage: install.py packages.json")
    sys.exit(0)

  config_file = sys.argv[1]
  Info("Using config file:", config_file)
  with open(config_file) as f:
    InstallAll(json.load(f))
