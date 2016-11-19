require 'fileutils'

module ProblemsHelper
  def write_to_file(file, dest)
    contents = file.read
    newFile = File.new(dest, "w")
    newFile.puts(contents)
    newFile.close
  end

  def file_extension_check(file)
    accepted_extensions = [".java", ".cpp", ".py"]

    extension = File.extname(file.path)

    return accepted_extensions.include? extension 
  end

  def file_size_check(file)
    size_range = 0..100.kilobytes

    #return size_range === file.read.length
    return true
  end
end
