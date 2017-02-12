require 'timeout'
require 'fileutils'
require 'console'

class CodeProcessor
  include ProblemsHelper
  RUNTIME = 3
  ROOT_DIR = Rails.root
  MUTEX_FILE = "#{ROOT_DIR}/tmp/mutex.lock"
  FIREJAIL_FLAGS = "--ignore=private --whitelist=#{ROOT_DIR}/tmp/codefile"

  def initialize(file, prob, user, lang)
    @file = file.read
    @problem = prob
    @user = user
    @language = lang
    @result = Submission.create(email: @user.email, problem_name: @problem.title, language: @language, runtime: 0, result: "Running", code: @file)
  end

  def run
  # Detect language
    case @language
    when "Java"
      run_java
    when "C++"
      run_cpp
    when "Python 2"
      run_python2
    when "Python 3"
      run_python3
    else
    end
  end

private

  def run_java
    # Locks the mutex so the current thread is the only one processing.
    file_lock = File.open(MUTEX_FILE, File::CREAT)
    file_lock.flock(File::LOCK_EX)
    # Write the file to disk
    write_to_file(@file, "#{ROOT_DIR}/tmp/codefile/Main.java")
    # Compile the Java file
    console = Console.new("javac #{ROOT_DIR}/tmp/codefile/Main.java")
    
    if (console.error?)
      output_result = "Compilation Error"
      computeTime = 0
    else
      console.close
      input = @problem.input
      begin
        read = ""
        Timeout.timeout(RUNTIME) do # Run the submission within the time limit
          startTime = Time.now
          # Run the compiled Java file
          console = Console.new("firejail #{FIREJAIL_FLAGS} java -cp #{ROOT_DIR}/tmp/codefile/ Main")
          # Write the input to the console line by line
          input.each_line do |line|
            console.write(line)
          end
          # Wait for the console to finish
          console.wait_to_finish
          # Read the output
          read = console.read_all
          read.strip!
          endTime = Time.now
          computeTime = endTime - startTime
        end

        # If the output is an exception
        if (console.error?) 
          output_result = "Runtime Exception"
        elsif (read == @problem.output) # If the output of the program is the same as the expected output
          output_result = "Accepted"
        else # Otherwise the answer is wrong
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
    # Update the result with the runtime and the result
    @result.update(runtime: computeTime)
    @result.update(result: output_result)
    # Reset the temporary folder
    reset_folder
    file_lock.flock(File::LOCK_UN)
  end
  
  def run_cpp
    # Locks the mutex so the current thread is the only one processing.
    file_lock = File.open(MUTEX_FILE, File::CREAT)
    file_lock.flock(File::LOCK_EX)
    # Write the file to disk
    write_to_file(@file, "#{ROOT_DIR}/tmp/codefile/Main.cc")
    # Compile the C++ file
    console = Console.new("g++ -o #{ROOT_DIR}/tmp/codefile/Main #{ROOT_DIR}/tmp/codefile/Main.cc")
    
    if (console.error?) # If there was a error in compilation
      output_result = "Compilation Error"
      computeTime = 0
    else
      console.close
      input = @problem.input
      begin
        read = ""
        Timeout.timeout(RUNTIME) do # Run the submission within the time limit
          startTime = Time.now
          # Run the compiled code file
          console = Console.new("firejail #{FIREJAIL_FLAGS} #{ROOT_DIR}/tmp/codefile/Main")
          # Write the input into the console line by line
          input.each_line do |line|
            console.write(line)
          end
          # Wait for the console to finish
          console.wait_to_finish
          # Read the output
          read = console.read_all
          read.strip!
          endTime = Time.now
          computeTime = endTime - startTime
        end
        
        # If the output is an exception
        if (console.error?) 
          output_result = "Runtime Exception"
        elsif (read == @problem.output) # If the output of the program is the same as the expected output
          output_result = "Accepted"
        else # Otherwise, the answer is wrong
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
    # Update the runtime and result of the submission
    @result.update(runtime: computeTime)
    @result.update(result: output_result)
    # Reset the temporary folder
    reset_folder
    # Unlock the lock on the file
    file_lock.flock(File::LOCK_UN)
      
  end
  
  def run_python2
    # Locks the mutex so the current thread is the only one processing.
    file_lock = File.open(MUTEX_FILE, File::CREAT)
    file_lock.flock(File::LOCK_EX)
    # Writes the file to disk
    write_to_file(@file, "#{ROOT_DIR}/tmp/codefile/Main.py")
    begin
      read = ""
      console = nil
      computeTime = 0
      input = @problem.input
      Timeout.timeout(RUNTIME) do # Run the submission within the time limit
        startTime = Time.now
        # Run the code
        console = Console.new("firejail #{FIREJAIL_FLAGS} python2 #{ROOT_DIR}/tmp/codefile/Main.py")
        # Write the input into the console line by line
        input.each_line do |line|
          console.write(line)
        end
        # Wait for the console to finish
        console.wait_to_finish
        # Read the output from the console
        read = console.read_all
        read.strip!
        endTime = Time.now
        computeTime = endTime - startTime
      end

      # If the output is an exception
      if (console.error?) 
        output_result = "Runtime Exception"
      elsif (read == @problem.output) # If the output of the program is the same as the expected output
        output_result = "Accepted"
      else # Otherwise, the answer is wrong
        output_result = "Wrong Answer"
      end
    rescue Timeout::Error # If the program did not finish within the time limit, kill the process
      Process.kill("INT", console.get_pid)
      console.close
      computeTime = RUNTIME
      output_result = "Time Limit Exceeded"
    end
    console.close
    # Update the results with the runtime and the result
    @result.update(runtime: computeTime)
    @result.update(result: output_result)
    # Reset the temporary folder
    reset_folder
    # Unlock the lock on the file
    file_lock.flock(File::LOCK_UN)
  end

  def run_python3
    # Locks the mutex so the current thread is the only one processing.
    file_lock = File.open(MUTEX_FILE, File::CREAT)
    file_lock.flock(File::LOCK_EX)
    # Write the file to disk
    write_to_file(@file, "#{ROOT_DIR}/tmp/codefile/Main.py")
    begin
      read = ""
      console = nil
      computeTime = 0
      input = @problem.input
      Timeout.timeout(RUNTIME) do # Run the submission within the time limit
        startTime = Time.now
        # Run the code
        console = Console.new("firejail #{FIREJAIL_FLAGS} python3 #{ROOT_DIR}/tmp/codefile/Main.py")
        # Write the input to the console line by line
        input.each_line do |line|
          console.write(line)
        end
        # Wait for the console to finish
        console.wait_to_finish
        # Read the output
        read = console.read_all
        read.strip!
        endTime = Time.now
        computeTime = endTime - startTime
      end

      # If the output is an exception
      if (console.error?) 
        output_result = "Runtime Exception"
      elsif (read == @problem.output) # If the output of the program is the same as the expected output
        output_result = "Accepted"
      else # Otherwise, the answer is wrong
        output_result = "Wrong Answer"
      end
    rescue Timeout::Error # If the program did not finish within the time limit, kill the process
      Process.kill("INT", console.get_pid)
      console.close
      computeTime = RUNTIME
      output_result = "Time Limit Exceeded"
    end
    console.close
    # Update the result with the runtime and the result
    @result.update(runtime: computeTime)
    @result.update(result: output_result)
    # Reset the folder
    reset_folder
    # Unlock the lock on the file
    file_lock.flock(File::LOCK_UN)
  end
  
  def reset_folder
    # Remove the folder and recreate it so the folder is reset
    FileUtils.remove_dir("#{ROOT_DIR}/tmp/codefile")
    Dir.mkdir("#{ROOT_DIR}/tmp/codefile")
  end
end