require 'timeout'
require 'fileutils'
require 'console'

class CodeProcessor
  include ProblemsHelper
  RUNTIME = 10
  MUTEX_FILE = '/home/peter/Ruby/onlinejudge/tmp/mutex.lock'

  def initialize(file, prob, user)
    @file = file
    @problem = prob
    @user = user
    @result = Submission.create(email: @user.email, problem_name: @problem.title, runtime: 0, result: "Running")
  end

  def run
    mutex = Rails.cache.read(:mutex)
    # Locks the mutex so the current thread is the only one processing.
    file_lock = File.open(MUTEX_FILE, File::CREAT)
    file_lock.flock(File::LOCK_EX)
    write_to_file(@file, '/home/peter/Ruby/onlinejudge/tmp/codefile/Main.java')
    console = Console.new('javac /home/peter/Ruby/onlinejudge/tmp/codefile/Main.java')
    
    if (console.error?)
      output_result = "Compilation Error"
      computeTime = 0
      puts "Error Compilation"
    else
      console.close
      input = @problem.input
      begin
        Timeout.timeout(RUNTIME) do # Run the program within the time limit
          startTime = Time.now
          console = Console.new('firejail java -cp /home/peter/Ruby/onlinejudge/tmp/codefile/ Main')
          input.each_line do |line|
            console.write(line)
          end
          console.wait_to_finish
          @read = console.read_all
          @read.strip!
          endTime = Time.now
          computeTime = endTime - startTime
        end
        p @read
        p @problem.output
        puts @read == @problem.output

        # If the output is an exception
        if (console.error?) 
          p console.read_error
          output_result = "Exception"
        elsif (@read == @problem.output) # If the output of the program is the same as the expected output
          output_result = "Accepted"
        else
          output_result = "Wrong Answer"
        end
      rescue Timeout::Error # If the program did not finish within the time limit, kill the process
        Process.kill("INT", console.get_pid)
        console.close
        computeTime = RUNTIME
        output_result = "Time Limit Exceeded"
      end
    end
    console.close
    @result.update(runtime: computeTime)
    @result.update(result: output_result)
    # Deletes the folder and recreates it to delete all files inside of it.
    FileUtils.remove_dir('/home/peter/Ruby/onlinejudge/tmp/codefile')
    Dir.mkdir('/home/peter/Ruby/onlinejudge/tmp/codefile')
    file_lock.flock(File::LOCK_UN)
  end
end
