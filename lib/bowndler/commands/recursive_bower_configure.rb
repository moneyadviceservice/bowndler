require 'pathname'
require 'bowndler/commands/bower_configure'

module Bowndler
  module Commands
    class RecursiveBowerConfigure
      class Gem
        attr_reader :manifest_path

        def initialize(name)
          gem_path = Bundler.rubygems.find_name(name).first.full_gem_path
          @manifest_path = Pathname.new(gem_path).join('bower.json.erb')
        end

        def uses_bowndler?
          manifest_path.exist?
        end
      end

      attr_reader :template_path

      def initialize(template_path)
        @template_path = template_path
      end

      def call
        all_bowndler_manifests.each do |path|
          Commands::BowerConfigure.new(path).call
        end
      end

    private

      def all_bowndler_manifests
        found_paths = Set.new
        find_bowndler_manifests_recursive(template_path, found_paths)

        found_paths
      end

      def find_bowndler_manifests_recursive(template_path, found_paths)
        found_paths << template_path
        manifest = File.read(template_path)

        # the \1 in the regex is a backreference that matches the opening quote
        gem_names = manifest.scan(/<%=\s*gem_path\s*\(?\s*(["'])(.*)\1\s*\)?\s*%>/)
          .map { |matches| matches[1] }

        gems = gem_names.map { |name| Gem.new(name) }

        gems.select(&:uses_bowndler?).each do |gem|
          find_bowndler_manifests_recursive(gem.manifest_path, found_paths)
        end
      end

    end
  end
end
