require 'erb'
require 'json'

module Bowndler
  class BowerConfigurator
    class ManifestTemplate
      def gem_path(name)
        Bundler.rubygems.find_name(name).first.full_gem_path
      end
    end

    attr_reader :manifest_template, :manifest_output_path
    private :manifest_template, :manifest_output_path

    def initialize(manifest_template_path, manifest_output_path)
      @manifest_output_path = manifest_output_path

      erb = ERB.new(IO.read(manifest_template_path))
      erb.filename = manifest_template_path
      @manifest_template = erb.def_class(ManifestTemplate, 'render()')
    end

    def generate_manifest
      bower_config = JSON.parse(manifest_template.new.render)
      bower_config = {:__warning__ => [
          " ************************************************************************** ",
          " *                                                                        * ",
          " * WARNING!                                                               * ",
          " * This file is generated. ANY CHANGES YOU MAKE MAY BE OVERWRITTEN.       * ",
          " *                                                                        * ",
          " * To add/edit bower dependencies, please edit bower.json.erb, and run    * ",
          " * `bower_configure` to regenerate this file.                             * ",
          " *                                                                        * ",
          " ************************************************************************** ",
      ]}.merge(bower_config)

      bower_json = JSON.pretty_generate(bower_config)
      File.open(manifest_output_path, 'w') do |file|
        file.write(bower_json)
      end
    end

  end
end
