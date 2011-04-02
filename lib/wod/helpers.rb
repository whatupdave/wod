module Wod
  module Helpers
    def home_directory
      ENV['HOME']
    end
    
    def wod_directory
      File.join home_directory, ".wod"
    end
    
    def last_page_file
      File.join wod_directory, "last_page.html"
    end
        
    def error(msg)
      STDERR.puts(msg)
      exit 1
    end
    
    def ask
      gets.strip
    end
    
    def display_formatted hashes, columns
      column_lengths = columns.map do |c|
        hashes.map { |h| h[c].length }.max
      end
      
      sorted = hashes.sort_by {|h| h[columns.first] }
      
      sorted.each do |row|
        column_index = 0
        puts " " + columns.map{ |column| text = row[column].ljust(column_lengths[column_index]); column_index += 1;  text }.join(" | ")
      end
    end
    
    
  end
end
