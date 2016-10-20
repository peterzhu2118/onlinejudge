require "io/console"

class CommandLine
  def initialize(loc)
    @command_line_loc = loc

    @cmd_line = IO.popen(@command_line_loc)
  end

  def run_cmd(command)
    @cmd_line.puts(command)
  end

  def get_response
    return @cmd_line.readline
  end
end