require 'timeout'
require 'fileutils'
require 'console'

class CodeProcessor
  include ProblemsHelper
  RUNTIME = 3

  def initialize(file, prob, user)
    @file = file
    @problem = prob
    @console = Console.new('/bin/sh')
    @console.run_cmd('cd /home/peter/Ruby/onlinejudge/tmp/codefile')
    @user = user
    @result = Submission.create(email: @user.email, problem_name: @problem.title, runtime: 0, result: "Running")
  end

  def run
    mutex = Rails.cache.read(:mutex)
    # Locks the mutex so the current thread is the only one processing.
    #mutex.lock
    write_to_file(@file, '/home/peter/Ruby/onlinejudge/tmp/codefile/Main.java')
    @console.run_cmd('javac Main.java')
    # If there is no output (compilation succeeded), then continue with running it.
    if (@console.end_of_file?)
      begin
        Timeout.timeout(RUNTIME) do # Run the program within the time limit
          startTime = Time.now
          @console.run_cmd('firejail java Main')
          endTime = Time.now
          computeTime = endTime - startTime
        end
        
        output = @console.read_all
        # If the output is an exception
        if (@output.casecmp('Exception in thread')) 
          output_result = "Exception"
        elsif (@console.read_all == prob.output) # If the output of the program is the same as the expected output
          output_result = "Accepted"
        else
          output_result = "Wrong Answer"
        end
      rescue Timeout::Error # If the program did not finish within the time limit, kill the process
        Process.kill("INT", @console.get_pid)
        computeTime = RUMTIME
      end
    else # If compilation failed
      output_result = "Compilation Error"
      computeTime = 0
    end
    @result.update(result: output_result)
    # Deletes the folder and recreates it to delete all files inside of it.
    FileUtils.remove_dir('~/Ruby/onlinejudge/tmp/codefile')
    Dir.mkdir('~/Ruby/onlinejudge/tmp/codefile')
    #mutex.unlock
  end
end
