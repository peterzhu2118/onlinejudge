require 'fileutils'

module ProblemsHelper
  def write_to_file(file, dest)
    newFile = File.new(dest, "w")
    newFile.puts(file)
    newFile.close
  end

  def file_extension_check(file, lang)
    extension = File.extname(file.path)
    
    puts extension
    
    case lang
    when "C++"
      return extension == ".cpp" || extension == ".cc"
    when "Java"
      return extension == ".java"
    when "Python 2"
      return extension == ".py"
    when "Python 3"
      return extension == ".py"
    else
      return false
    end
  end

  def file_size_check(file)
    size_range = 0..50.kilobytes

    return size_range === file.size
  end
  
  def save_file(file, username, filename)
    path = File.new("#{Rails.root}/tmp/submissions/#{username}/#{filename}")
    unless File.directory(File.dirname(path))
      FileUtils.mkdir_p(File.dirname(path))
    end
    file.rewind
    write_to_file(file, path.to_path)
  end
end
