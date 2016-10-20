require "io/console"

# Opens a terminal process
class CommandLine
  def initialize(loc)
    @command_line_loc = loc

    @cmd_line = IO.popen(@command_line_loc, "r+")
  end

  # Run the specified command
  def run_cmd(command)
    @cmd_line.puts(command)
  end

  # Returns the response by the command
  def get_response
    return @cmd_line.readline
  end
end
