require_relative "book"
require_relative "digital_book"
require_relative "audio_book"
require_relative "../modules/searchable"



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