class ConfigFile
  def initialize(path)
    @file_reader =File.new(path, "r")
    @term_loc
    @list_lang = Array.new

    self.read_file
  end

  private

  def read_file()
    while (line = @file_reader.gets)
      if (line[0] == "#")
        next
      elsif (line[0..3] == "term")
        @term_loc = line[4..(line.length - 1)].strip
      elsif (line[0..3] == "lang")
        @list_lang.insert(line[4..(line.length - 1)].strip)
      elsif
        @list_lang[list_lang.length - 1]
      end
    end
  end
end

class Language
  def initialize(name)
    @lang_name = name
    @lang_line = Array.new
  end

  def add_line(line)
    @lang_line[@lang_line.length] = line
  end
end




puts OS.windows?
filereader = FileReader.new("./LICENSE.md","r")
puts filereader.read
