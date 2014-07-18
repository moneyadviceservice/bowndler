module Bowndler
  class ExecAtExit

    class << self
      def register(*args)
        puts "exec_at_exit: #{args}"
        at_exit { new(*args).run }
      end
    end

    attr_reader :command, :working_dir

    def initialize(command, working_dir)
      @command = command.to_s
      @working_dir = working_dir
    end

    def run
      run_command if is_exiting_cleanly?
    end

  protected

    def run_command
      Dir.chdir(working_dir) { exec(command) }
    end

    def is_exiting_cleanly?
      $!.nil? || ($!.is_a?(SystemExit) && $!.success?)
    end

  end
end
