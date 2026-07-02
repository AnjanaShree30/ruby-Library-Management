module Displayable
  def display
    puts "title: #{@title}"
    puts "author: #{@author}"
    puts "Year  : #{@year}"
    puts "Genre : #{@genre}"
    puts "Age   : #{age} years"
  end
end