module Wod
  module Helpers
    def home_directory
      ENV['HOME']
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
      
      sorted.each.with_index do |h, i|
        puts " " + columns.map.with_index{ |c, i| h[c].ljust(column_lengths[i]) }.join(" | ")
      end
    end
    
    
  end
end
