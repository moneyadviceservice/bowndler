require 'bowndler/exec_at_exit'
require 'bowndler/hook_lock'
require 'bundler'

module Bowndler
  module Hook
    extend self

    def create
      create_hook if can_hook?
    end

  private

    def create_hook
      ExecAtExit.register("bowndler update", gemfile_dir)
    end

    def can_hook?
      return false if ENV['SKIP_BOWNDLER']

      hookable_process? && acquire_hook_lock
    end

    def hookable_process?
      bundler_running? && bundler_command_modifies_gemfile? && is_master_bundler_process?
    end

    def acquire_hook_lock
      HookLock.new(gemfile_dir).acquire
    end

    def gemfile_dir
      File.dirname(Bundler.default_gemfile)
    end

    def bundler_running?
      $PROGRAM_NAME =~ /bundle$/
    end

    def bundler_command_modifies_gemfile?
      ARGV.empty? || ARGV.any? { |a| ['install', 'update'].include?(a) }
    end

    def is_master_bundler_process?
      # make sure that the parent process isn't "bundle"
      /bundle$/ !~ `ps -o comm= -p #{Process.ppid} 2>/dev/null`
    end

  end
end
