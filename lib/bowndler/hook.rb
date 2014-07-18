require 'bundler'

module Bowndler
  module Hook
    extend self

    attr_accessor :hook_registered
    private :hook_registered=
    alias :hook_registered? :hook_registered

    def create
      return unless hookable_process?

      create_hook
      self.hook_registered = true
    end

  private

    def hookable_process?
      return if ENV['SKIP_BOWNDLER']
      return if hook_registered?

      return bundler_running? && bundler_command_modifies_gemfile?
    end

    def create_hook
      at_exit { bowndler_update if is_exiting_cleanly? }
    end

    def bowndler_update
      return unless bowndler_installed?

      Dir.chdir(File.dirname(Bundler.default_gemfile)) do
        exec "bowndler update"
      end
    end

    def is_exiting_cleanly?
      $!.nil? || ($!.is_a?(SystemExit) && $!.success?)
    end

    def bundler_running?
      $PROGRAM_NAME =~ /bundle$/
    end

    def bundler_command_modifies_gemfile?
      ARGV.empty? || ARGV.any? { |a| ['install', 'update'].include?(a) }
    end

    def bowndler_installed?
      bowndler_path = `which bowndler 2>/dev/null`

      !bowndler_path.to_s.empty?
    end

  end
end
