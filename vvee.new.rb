#!/usr/bin/env ruby
#
# MIT License
#
# Copyright (c) 2024 Julian Kahlert <90937526+juliankahlert@users.noreply.github.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE

##### TOOLS #####

require 'json'
require 'yaml'

class PackageJson
  def initialize(dir)
    @path = File.join(dir, 'package.json')
    @package = {}
  end

  def load
    @package = JSON.load_file(@path)
    self
  rescue
    @package = {}
    self
  end

  def main(val)
    @package['main'] = val
  end

  def add_script(key, val)
    @package['scripts'] ||= {}
    @package['scripts'][key.to_s] = val
  end

  def save
    File.write(@path, JSON.pretty_generate(@package))
  end
end

class VVEEScaffoldModuleBuilder < ScaffoldModuleBuilder
  class VVEEScaffoldModule < ScaffoldModule
    def initialize(cfg, asset_file)
      super(cfg[:dir])

      @assets = YAML.load_file(asset_file)
      @pkg = PackageJson.new(@dir)
      @cfg = cfg
    end

    def run
      system("rm --force --recursive #{@dir}")
      system("npm init vite #{File.basename(@dir)} -- --template vue")
      system("cd #{@dir} && npm install")
      system("cd #{@dir} && npm install -D unplugin-vue-components unplugin-auto-import")
      system("cd #{@dir} && npm install --save-dev yaml")
      system("cd #{@dir} && npm install --save-dev electron")
      system("cd #{@dir} && npm install --save-dev electron-builder")

      File.write(File.join(@dir, 'electron-builder.config.cjs'), @assets['electron-builder.config.cjs'])
      File.write(File.join(@dir, 'CHANGELOG.yaml'), @assets['CHANGELOG.yaml'])
      File.write(File.join(@dir, 'vite.config.js'), @assets['vite.config.js'])
      File.write(File.join(@dir, 'preload.js'), @assets['preload.js'])
      File.write(File.join(@dir, 'main.cjs'), @assets['main.cjs'])

      @pkg.load
      @pkg.main('main.cjs')
      @pkg.add_script('dev', 'vite')
      @pkg.add_script('build', 'vite build')
      @pkg.add_script('serve', 'vite serve')
      @pkg.add_script('electron:start', 'electron .')
      @pkg.add_script('electron:build', 'electron-builder build --config electron-builder.config.cjs --config.asar=false')
      @pkg.save
      true
    end
  end

  def initialize
    @asset_file = "#{__FILE__}.yaml"    
  end

  def build(cfg)
    return nil unless cfg && cfg[:dir]

    VVEEScaffoldModule.new(cfg, @asset_file)
  end

  def name
    'vite-vue-element-electron'
  end
end

ScaffoldModuleBuilder.register(VVEEScaffoldModuleBuilder.new())

