require 'csv'
require 'fileutils'
SAVE_FILE = "books.csv"


class BookNotFoundError < StandardError
  def initialize(title)
    super("Book not found: #{title}")
  end
end

class InvalidInputError < StandardError
end

module Displayable
  def display
    puts "title: #{@title}"
    puts "author: #{@author}"
    puts "Year  : #{@year}"
    puts "Genre : #{@genre}"
    puts "Age   : #{age} years"
  end

  def to_s
    "#{@title} by #{@author} (#{@year}) - #{@genre}"
  end
end

module Exportable
  def to_csv_row
    fields = [@title, @author, @year, @genre]
    fields.map { |field| "\"#{field}\"" }.join(",")
  end
end

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

class DigitalBook < Book
  attr_accessor :url

  def initialize(title, author, year, genre, url)
    super(title, author, year, genre)
    @url = url
  end

  def display
    super
    puts "URL   : #{@url}"
  end
end

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
module Searchable
  def search_by_title(title)
    @books.find do |book|
      book.title.downcase.include?(title.downcase)
    end
  end

  def search_by_genre(genre)
    @books.select do |book|
      book.genre.downcase.include?(genre.downcase)
    end
  end
end

class Library
  include Searchable
  attr_reader :books

  def initialize
    @books = []
  end
  def all_books
    @books
  end

  def add_digital_book(title,
    author,
    year,
    genre,
    url
    )
    @books.push(
      DigitalBook.new(
        title,
        author,
        year,
        genre,
        url
      )
    )

    puts "Digital Book added"
  end
  
  def add_audiobook(
    title,
    author,
    year,
    genre,
    duration_minutes
    )
    @books.push(
      AudioBook.new(
        title,
        author,
        year,
        genre,
        duration_minutes))
    
    puts "Audiobook added!"
  end
  def add(title, author, year, genre)
    @books.push(Book.new(title, author, year, genre))
    puts "Book added!"
  end

  def list(limit = nil)
    collection = limit ? @books.first(limit) : @books

    if collection.empty?
      puts "No books available."
      return
    end

    collection.each do |book|
      book.display
    end
  end

  def delete(title)
    before = @books.length
    @books.reject! do |book|
      book.title.downcase == title.downcase
    end
    if @books.length < before
      puts "Book deleted!"
    else
      raise BookNotFoundError.new(title)
    end
  end

  def summary
    if @books.empty?
      puts "Library is empty."
      return
    end

    oldest_book = @books.min_by(&:year)
    recent_books = @books.count(&:recent?)

    puts "Total books: #{@books.length}"

    puts "\nOldest Book:"
    oldest_book.display

    puts "Recent books (last 5 years): #{recent_books}"
  end

  def dev_stats
    puts "Total books: #{@books.count}"

    books_after_2000 = @books.count do |book|
      book.year > 2000
    end

    puts "Books after 2000: #{books_after_2000}"

    authors = @books.map(&:author).uniq

    puts "\nAuthors:"
    authors.each do |author|
      puts author
    end
  end

  def books_between_years(start_year, end_year)
    if end_year < start_year
      puts "Invalid range."
      return
    end

    books_in_range = @books.select do |book|
      book.year >= start_year &&
      book.year <= end_year
    end

    books_in_range = books_in_range.sort_by(&:year)

    if books_in_range.empty?
      puts "No books found in that range."
    else
      books_in_range.each do |book|
        book.display
      end
    end
  end

  def update_title(current_title, new_title)
    book = @books.find do |b|
      b.title.downcase == current_title.downcase
    end

    if book.nil?
      puts "Book not found!"
      return
    end

    book.title = new_title
    puts "Book title updated!"
  end

  private

  def find_index(title)
    @books.index do |book|
      book.title.downcase == title.downcase
    end
  end
end

def show_menu
  puts "\n=== Library Management System ==="
  puts "1. Add a book"
  puts "2. List first 3 books"
  puts "3. List all books"
  puts "4. Delete a book"
  puts "5. Search for a book"
  puts "6. Library Summary"
  puts "7. Dev Stats"
  puts "8. Exit"
  puts "9.Add a digital book"
  puts "10. Add Audiobook"
  puts "11. Books Between Years"
  puts "12. Update Book Title"
  puts "13. sort by year"
  puts "14. Export book to clipboard format"
end

def backup_library
  if File.exist?(SAVE_FILE)
    FileUtils.cp(
      SAVE_FILE,
      "books_backup.csv"
    )

    puts "Backup created: books_backup.csv"
  end
end

def save_library(library)
  CSV.open(SAVE_FILE, "w") do |csv|

    csv << [
      "title",
      "author",
      "year",
      "genre",
      "type",
      "url",
      "duration_minutes"
    ]

    library.all_books.each do |book|

      if book.is_a?(DigitalBook)

        csv << [
          book.title,
          book.author,
          book.year,
          book.genre,
          "digital",
          book.url,
          ""
        ]

      elsif book.is_a?(AudioBook)

        csv << [
          book.title,
          book.author,
          book.year,
          book.genre,
          "audio",
          "",
          book.duration_minutes
        ]

      else

        csv << [
          book.title,
          book.author,
          book.year,
          book.genre,
          "physical",
          "",
          ""
        ]

      end

    end
  end

  puts "Library saved."
end

def load_library(library)

  return unless File.exist?(SAVE_FILE)

  CSV.foreach(SAVE_FILE, headers: true) do |row|

    case row["type"]

    when "digital"

      library.add_digital_book(
        row["title"],
        row["author"],
        row["year"],
        row["genre"],
        row["url"]
      )

    when "audio"

      library.add_audiobook(
        row["title"],
        row["author"],
        row["year"],
        row["genre"],
        row["duration_minutes"]
      )

    else

      library.add(
        row["title"],
        row["author"],
        row["year"],
        row["genre"]
      )

    end

  end

  puts "Loaded #{library.all_books.length} books from file."

end

def validate_input(value, field_name)
  if value.strip.empty?
    puts "#{field_name} cannot be blank."
    return false
  end

  true
end

library = Library.new
load_library(library)

at_exit do
  backup_library
  save_library(library)
end

begin
  loop do
    show_menu
    print "Enter your choice: "
    choice = gets.chomp
    case choice
    when "1"
      print "Enter title: "
      title = gets.chomp.strip
      next unless validate_input(title, "Title")
      print "Enter author: "
      author = gets.chomp.strip
      next unless validate_input(author, "Author")
      print "Enter year: "
      year = gets.chomp.strip
      unless year.match?(/^\d+$/)
        raise InvalidInputError,
        "Year must be a number"
      end
      print "Enter genre: "
      genre = gets.chomp.strip
      genre = "Uncategorized" if genre.empty?
      library.add(title, author, year, genre)
    
    when "2"
      library.list(3)
    
    when "3"
      library.list
    
    when "4"
      print "Enter title to delete: "
      title = gets.chomp
      library.delete(title)
    
    when "5"
      print "Enter title to search: "
      title = gets.chomp
      book = library.search_by_title(title)
      
      if book
        book.display
      else
        raise BookNotFoundError.new(title)
      end
    
    when "6"
      library.summary
    
    when "7"
      library.dev_stats
    
    when "8"
      puts "Goodbye!"
      break
    
    when "9"
      print "Enter title: "
      title = gets.chomp
      print "Enter author: "
      author = gets.chomp
      print "Enter year: "
      year = gets.chomp
      
      unless year.match?(/^\d+$/)
        raise InvalidInputError,
        "Year must be a number"
      end
      
      print "Enter genre: "
      genre = gets.chomp
      
      print "Enter URL: "
      url = gets.chomp
      
      library.add_digital_book(
        title,
        author,
        year,
        genre,
        url
        )
    
    when "10"
      print "Enter title: "
      title = gets.chomp
      print "Enter author: "
      author = gets.chomp
      print "Enter year: "
      year = gets.chomp
      unless year.match?(/^\d+$/)
        raise InvalidInputError,
        "Year must be a number"
      end
      print "Enter genre: "
      genre = gets.chomp
      print "Enter duration in minutes: "
      duration = gets.chomp
      unless duration.match?(/^\d+$/) &&
        duration.to_i > 0
        raise InvalidInputError,
        "Duration must be a positive integer"
      end
      library.add_audiobook(
        title,
        author,
        year,
        genre,
        duration
        )
      
    when "11"
      print "Enter start year: "
      start_year = gets.chomp.to_i
      print "Enter end year: "
      end_year = gets.chomp.to_i
      
      library.books_between_years(
        start_year,
        end_year
        )
      
    when "12"
      print "Enter current title: "
      current_title = gets.chomp
      print "Enter new title: "
      new_title = gets.chomp.strip
      
      next unless validate_input(
        new_title,
        "New Title"
        )
        
        library.update_title(
          current_title,
          new_title
          )
    
    
    when "13"
      if library.books.empty?
        puts "No books to sort."
      else
        library.books.sort.each do |book|
          book.display
        end
      end
    
    when "14"
      print "Enter genre: "
      genre = gets.chomp
      
      books = library.search_by_genre(genre)
      if books.empty?
        puts "Book not found!"
      else
        books.each do |book|
          puts book.to_csv_row
        end
      end
    
    else
      puts "Invalid choice."
    end
  end

rescue BookNotFoundError => e
  puts "Error: #{e.message}"
rescue InvalidInputError => e
  puts "Invalid Input: #{e.message}"
rescue Interrupt
  puts "\nGoodbye!"
ensure
  puts "Session ended."
end