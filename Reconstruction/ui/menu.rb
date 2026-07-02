require "csv"
require "fileutils"

require_relative "../models/library"
require_relative "../models/book"
require_relative "../models/digital_book"
require_relative "../models/audio_book"
require_relative "../models/errors"

require_relative "../modules/displayable"
require_relative "validators"

SAVE_FILE = File.join(__dir__, "..", "data", "books.csv")


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
  puts "9. Add a Digital Book"
  puts "10. Add Audiobook"
  puts "11. Books Between Years"
  puts "12. Update Book Title"
  puts "13. Sort by Year"
  puts "14. Export Books"
end

def backup_library
  if File.exist?(SAVE_FILE)
    FileUtils.cp(SAVE_FILE, "data/books_backup.csv")
    puts "Backup created."
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

def run_menu(library)
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
        raise InvalidInputError, "Year must be a number"
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

      raise InvalidInputError, "Year must be a number" unless year.match?(/^\d+$/)

      print "Enter genre: "
      genre = gets.chomp

      print "Enter URL: "
      url = gets.chomp

      library.add_digital_book(title, author, year, genre, url)

    when "10"

      print "Enter title: "
      title = gets.chomp

      print "Enter author: "
      author = gets.chomp

      print "Enter year: "
      year = gets.chomp

      raise InvalidInputError, "Year must be a number" unless year.match?(/^\d+$/)

      print "Enter genre: "
      genre = gets.chomp

      print "Enter duration: "
      duration = gets.chomp

      unless duration.match?(/^\d+$/) && duration.to_i > 0
        raise InvalidInputError, "Duration must be positive"
      end

      library.add_audiobook(title, author, year, genre, duration)

    when "11"

      print "Start year: "
      start_year = gets.chomp.to_i

      print "End year: "
      end_year = gets.chomp.to_i

      library.books_between_years(start_year, end_year)

    when "12"

      print "Current title: "
      current = gets.chomp

      print "New title: "
      new_title = gets.chomp.strip

      next unless validate_input(new_title, "New Title")

      library.update_title(current, new_title)

    when "13"

      if library.books.empty?
        puts "No books to sort."
      else
        library.books.sort.each(&:display)
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
      puts "Invalid choice"

    end
  end
end