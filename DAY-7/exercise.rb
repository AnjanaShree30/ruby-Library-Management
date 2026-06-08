class Book
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

  def display
    puts "Title : #{@title}"
    puts "Author: #{@author}"
    puts "Year  : #{@year}"
    puts "Genre : #{@genre}"
    puts "Age   : #{age} years"
    puts "-" * 30
  end

  def to_s
    "#{@title} by #{@author} (#{@year}) - #{@genre}"
  end
end

class Library
  def initialize
    @books = []
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

  def search(title)
    @books.find do |book|
      book.title.downcase.include?(title.downcase)
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
      puts "Book not found!"
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

  def find_index(title)
    @books.index do |book|
      book.title.downcase == title.downcase
    end
  end
  
  def stats
    if @books.empty?
        return {
            total: 0,
            by_genre: {},
            average_year: 0
        }
    end
    by_genre = {}
    
    @books.each do |book|
        genre = book.genre
        
        if by_genre.key?(genre)
            by_genre[genre] += 1
        else
            by_genre[genre] = 1
        end
    end
    average_year =
    (@books.sum(&:year).to_f / @books.length).round
    
    {
        total: @books.length,
        by_genre: by_genre,
        average_year: average_year
    }
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
  puts "9. Books Between Years"
  puts "10. Update Book Title"
  puts "11. Library Stats"
end

def validate_input(value, field_name)
  if value.strip.empty?
    puts "#{field_name} cannot be blank."
    return false
  end

  true
end

library = Library.new

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
    next unless validate_input(year, "Year")

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

    book = library.search(title)

    if book
      book.display
    else
      puts "Book not found!"
    end

  when "6"
    library.summary

  when "7"
    library.dev_stats

  when "8"
    puts "Goodbye!"
    break

  when "9"
    print "Enter start year: "
    start_year = gets.chomp.to_i

    print "Enter end year: "
    end_year = gets.chomp.to_i

    library.books_between_years(start_year, end_year)

  when "10"
    print "Enter current title: "
    current_title = gets.chomp

    print "Enter new title: "
    new_title = gets.chomp.strip

    next unless validate_input(new_title, "New Title")

    library.update_title(current_title, new_title)

  when "11"
    stats = library.stats
    puts "Total Books: #{stats[:total]}"
    puts "Average Year: #{stats[:average_year]}"
    puts "Books By Genre:"
    stats[:by_genre].each do |genre, count|
        puts "#{genre}: #{count}"
    end
else
    puts "Invalid choice"
end
end