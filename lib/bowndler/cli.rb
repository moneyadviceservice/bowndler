require 'bowndler/bower_configurator'
require 'bundler'

module Bowndler
  class CLI < Thor
    desc 'bower_configure', 'Generates bower.json from bower.json.erb'
    def bower_configure
      gemfile_dir = Bundler.default_gemfile.dirname
      manifest_template_path = File.join(gemfile_dir, 'bower.json.erb')
      manifest_output_path = File.join(gemfile_dir, 'bower.json')

      BowerConfigurator.new(manifest_template_path, manifest_output_path).generate_manifest
    end

    def method_missing(method_name, *args, &block)
      invoke :bower_configure, []
      exec "bower #{method_name} #{args.join(' ')}"
    end
  end
end
