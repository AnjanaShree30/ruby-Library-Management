require_relative "../modules/displayable"
require_relative "../modules/exportable"

class Book
  include Displayable
  include Comparable
  include Exportable
  attr_accessor :title, :author, :year, :genre

  def initialize(title, author, year, genre)
    @title = title
    @author = author
    @year = year.to_i
    @genre = genre
  end

  def age
    Time.now.year - @year
  end

  def recent?
    age <= 5
  end

  def <=> (other)
    @year <=> other.year
  end
end