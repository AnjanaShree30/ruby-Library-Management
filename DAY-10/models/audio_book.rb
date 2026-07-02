require_relative "book"

class AudioBook < Book
  attr_accessor :duration_minutes

  def initialize(title, author, year, genre, duration_minutes)
    super(title, author, year, genre)
    @duration_minutes = duration_minutes.to_i
  end

  def display
    super

    hours = @duration_minutes / 60
    minutes = @duration_minutes % 60

    puts "Duration: #{hours}h #{minutes}m"
  end
end