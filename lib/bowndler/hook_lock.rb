require 'fileutils'

module Bowndler
  class HookLock

    attr_reader :lock_file

    def initialize(working_dir)
      @lock_file = File.expand_path('.bowndler_hook_lock', working_dir)
    end

    def locked?
      File.exist?(lock_file)
    end

    def acquire
      file = File.new(lock_file, File::WRONLY|File::CREAT|File::EXCL)
      file.close

      true
    rescue Errno::EEXIST
      false
    end

    def release
      FileUtils.rm_f(lock_file)
    end

  end
end
