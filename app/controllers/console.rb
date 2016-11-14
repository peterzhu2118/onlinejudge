require "io/console"

class Console
  def initialize(loc)
    @command_line_loc = loc

    @cmd_line = IO.popen(@command_line_loc, "r+")
  end

  def run_cmd(command)
    @cmd_line.puts(command)
  end

  def get_response
    return @cmd_line.readline
  end

  def read_all
    return @cmd_line.read
  end

  def get_pid
    return @cmd_line.pid
  end

  def end_of_file?
    return @cmd_line.eof?
  end

  def close
    @cmd_line.close
  end
end
