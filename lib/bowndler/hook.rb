require 'bundler'

module Bowndler
  module Hook
    extend self

    attr_accessor :hook_registered
    private :hook_registered=
    alias :hook_registered? :hook_registered

    def create
      return if hook_registered?
      return unless bundler_running? && bundler_command_modifies_gemfile?
      return unless bowndler_installed?

      create_hook
      self.hook_registered = true
    end

  private

    def create_hook
      at_exit { bowndler_update if is_exiting_cleanly? }
    end

    def bowndler_update
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
      ['', 'install', 'update'].include?($FILE_NAME.to_s.downcase)
    end

    def bowndler_installed?
      return `which bowndler 1>&2>/dev/null` == 0
    end

  end
end
