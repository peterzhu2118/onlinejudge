require 'timeout'
require 'fileutils'
require 'console'

require 'session'

class CodeProcessor
  include ProblemsHelper
  RUNTIME = 3

  def initialize(file, prob, user)
    @file = file
    @problem = prob
    @user = user
    @result = Submission.create(email: @user.email, problem_name: @problem.title, runtime: 0, result: "Running")
    @console = Session::Bash.new
  end

  def run
    mutex = Rails.cache.read(:mutex)
    # Locks the mutex so the current thread is the only one processing.
    #mutex.lock
    write_to_file(@file, '/home/peter/Ruby/onlinejudge/tmp/codefile/Main.java')
    puts 'no1'
    stdout, stderr = @console.execute 'javac /home/peter/Ruby/onlinejudge/tmp/codefile/Main.java'
    stderr.strip!
    
    if (stderr.length > 0)
      output_result = "Compilation Error"
      computeTime = 0
      puts "Error : #{stderr}"
    else
      begin
        Timeout.timeout(RUNTIME) do # Run the program within the time limit
          startTime = Time.now
          stdout, stderr = @console.execute 'java -cp /home/peter/Ruby/onlinejudge/tmp/codefile/ Main'
          endTime = Time.now
          computeTime = endTime - startTime
        end
        stdout.strip!
        stderr.strip!
        puts "Out : #{stdout}"
        puts "Error : #{stderr}"
        # If the output is an exception
        if (stderr.length > 0) 
          output_result = "Exception"
        elsif (stdout == @problem.output) # If the output of the program is the same as the expected output
          output_result = "Accepted"
        else
          output_result = "Wrong Answer"
        end
      rescue Timeout::Error # If the program did not finish within the time limit, kill the process
        #Process.kill("INT", @console.get_pid)
        @console.close
        computeTime = RUNTIME
        output_result = "Time Limit Exceeded"
      end
    end
    @result.update(result: output_result)
    # Deletes the folder and recreates it to delete all files inside of it.
    FileUtils.remove_dir('/home/peter/Ruby/onlinejudge/tmp/codefile')
    Dir.mkdir('/home/peter/Ruby/onlinejudge/tmp/codefile')
    #mutex.unlock
  end
end
