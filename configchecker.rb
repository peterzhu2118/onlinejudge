# Represents a config file, reads from the file and stores the values
class ConfigFile
  def initialize(path)
    @file_reader =File.new(path, "r")
    @term_loc # Terminal location
    @list_lang = Array.new # List of languages

    # Calls the method to read the file
    read_file
  end

  def to_s
    return "Terminal Location: #{@term_loc}, Languages: #{@list_lang}"
  end

  # PRIVATE METHODS FROM HERE
  private

  def read_file()
    while (line = @file_reader.gets)
      if (line.length == 0) # If the line length is 0, skip it
        next
      elsif (line[0] == "#") # If the line starts with a comment, skip it
        next
      elsif (line[0..3] == "term") # If the line is a terminal location
        @term_loc = line[4..(line.length - 1)].strip
      elsif (line[0..3] == "lang") # If the line declares a new language
        @list_lang << Language.new(line[4..(line.length - 1)].strip)
      elsif (@list_lang.length > 0) # If the line is instructions for a new language
        @list_lang[@list_lang.length - 1].add_line(line.strip)
      end
    end
  end


end

# Represents a language
class Language
  def initialize(name)
    @lang_name = name # Language name
    @lang_line = Array.new # List of commands for the lenguage
  end

  # Adds a line of command for this language
  def add_line(line)
    @lang_line[@lang_line.length] = line
  end

  def to_s
    return "{Lang: #{@lang_name}, Commands: #{@lang_line}}"
  end
end
