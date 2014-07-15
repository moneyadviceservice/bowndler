require 'bowndler/commands'
require 'bundler'

module Bowndler
  class CLI < Thor
    desc 'bower_configure', 'Generates bower.json from bower.json.erb'
    option :template, banner: 'Template file path (will autodetect if left blank)'
    option :output, banner: 'Output file path (defaults to "bower.json" in template directory)'
    def bower_configure
      template_path = options.include?(:template) ?
        File.expand_path(options[:template]) :
        Bundler.default_gemfile.dirname.join('bower.json.erb')

      output_path = options.include?(:output) ?
        File.expand_path(options[:output]) :
        template_path.join('../bower.json')

      Commands::BowerConfigure.new(template_path).call(output_path)
    end

    desc 'autohook', 'Update a gemfile to automatically configure bower when bundling'
    option :gemfile, banner: 'Path to the gemfile to update (will autodetect gemfile if left blank)'
    def autohook
      gemfile = options.include?(:gemfile) ?
        File.expand_path(options[:gemfile]) :
        Bundler.default_gemfile

      Commands::Autohook.new(gemfile).call
    end

    def method_missing(method_name, *args, &block)
      invoke :bower_configure, []
      exec "bower #{method_name} #{args.join(' ')}"
    end
  end
end
