require 'erb'
require 'json'

module Bowndler
  module Commands
    class BowerConfigure

      class GemAwareTemplate
        def gem_path(name)
          Bundler.rubygems.find_name(name).first.full_gem_path
        end
      end

      attr_reader :template
      private :template

      def initialize(template_path)
        erb = ERB.new(IO.read(template_path))
        erb.filename = template_path.to_s
        @template = erb.def_class(GemAwareTemplate, 'render()').new
      end

      def call(output_path)
        bower_config = JSON.parse(template.render)
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
        File.open(output_path, 'w') do |file|
          file.write(bower_json)
        end
      end
    end
  end
end
