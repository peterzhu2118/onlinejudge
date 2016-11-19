require "open3"

class Console
  def initialize(cmd)
    @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(cmd)
  end

  def write(str)
    @stdin.puts(str)
  end

  def end_write
    @stdin.close
  end

  def error?
    !(@stderr.eof?)
  end

  def read_error
    return @stderr.read
  end

  def read_line
    return @stdout.readline
  end

  def read_all
    return @stdout.read
  end

  def end_of_file?
    return @stdout.eof?
  end

  def wait_to_finish
    @wait_thr.value
  end

  def get_pid
    return @wait_thr.pid
  end

  def close
    @stdin.close
    @stdout.close
    @stderr.close
  end
end
