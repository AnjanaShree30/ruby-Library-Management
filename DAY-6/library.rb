class Book
    attr_accessor :title, :author, :year, :genre

    def initialize(title, author, year, genre)
        @title=title
        @author=author
        @year=year
        @genre=genre
    end

    def display
        puts "title: #{@title}"
        puts "author: #{@author}"
        puts "year: #{@year}"
        puts "genre: #{@genre}"
    end

    def to_s
        "#{@title} by #{@author} (#{@year}) - #{@genre}"
    end
end

def show_menu
    puts "\n === Library Managament System ==="
    puts "1.Add a book"
    puts "2.List first 3 books"
    puts "3.List all the books"
    puts "4.delete a book"
    puts "5.search for a book"
    puts "6.Library Summary"
    puts "7.dev stats"
    puts "8.exit"
    puts "9.Books Between years"
    puts "10.Update book title"
end

def validate_input(value,field_name)
    if value.strip.empty?
        puts "#{field_name} Can't be blank"
        return false
    end
    true
end
def add_book(books)
    print "enter title:"
    title = gets.chomp

    return unless validate_input(title,"Title")

    print "enter author:"
    author = gets.chomp

    return unless validate_input(author,"Author")
    print "enter year:"
    year = gets.chomp

    return unless validate_input(year,"year")
    
    print "enter genre:"
    genre = gets.chomp

    return unless validate_input(genre,"Genre")
    
    books.push(Book.new(title,author,year,genre))

    puts "book added"
end

def list_books(books)
    display_books(books.first(3))
end

def list_all_books(books)
    display_books(books)
end

def delete_book(books)
    print "enter title to delete book:"
    title = gets.chomp

    book_found=books.any? do |book|
        book.title.downcase == title.downcase
    end

    if !book_found
        puts "book not found!"
    else
        books.reject! do |book|
            book.title.downcase == title.downcase
        end
        puts "book deleted"
    end
end

def search_book(books)
    print "enter title to search for a book:"
    title = gets.chomp

    found_book = books.find do |book|
        book.title.downcase == title.downcase
    end

    if !found_book
        puts "book not found"
    else
        display_books([found_book])
    end
end

def library_summary(books)

    if books.empty?
        puts "Library is empty"
    else
        total_books = books.length

        most_recent_book = books.last

        oldest_book = books.min_by do |book|
            book.year.to_i
        end

        puts "total books: #{total_books}"
        puts "most recent book:"
        display_books([most_recent_book])
        puts "oldest book:"
        display_books([oldest_book])
    end
end

def dev_stats(books)
    total_books=books.count
    puts "total books: #{total_books}"

    books_after_2000=books.count do |book|
        book.year.to_i > 2000
    end
    puts "books after 2000: #{books_after_2000}"

    authors=books.map do |book|
        book.author
    end.uniq

    puts "authors:\n"
    authors.each do |author|
        puts "#{author}"
    end
end

def books_between_years(books)
    print "enter the start year:"
    start_year = gets.chomp.to_i

    print "enter the end year:"
    end_year = gets.chomp.to_i

    if end_year < start_year
        puts "Invalid range"
    
    else
        books_in_range = books.select do |book|
            book.year.to_i >=start_year && book.year.to_i <=end_year
        end

        sort_books=books_in_range.sort_by do |book|
            book.year.to_i
        end

        if sort_books.empty?
            puts "no books in the given range"
        else
            display_books(sort_books)
        end
    end
end

def display_books(books)
    books.each do |b|
        b.display
    end
end

def update_book_title(books)
    print "enter the current title of the book:"
    current_title =gets.chomp

    current_book = books.find do |b|
        b.title.downcase == current_title.downcase
    end

    if !current_book
        puts "book not found"
    else
        print "enter the new title:"
        new_title = gets.chomp
        new_title.strip!
        return unless validate_input(new_title,"New Title")

        puts "preview:"
        puts "old title: #{current_title}"
        puts "new title: #{new_title}"
        puts "confirm update? (y/n)"

        confirm =gets.chomp.downcase

        if confirm =="y"
            current_book.title = new_title
            puts "book title updated"
        else
            puts "update cancelled"
        end
    end
end

books=[]
loop do
    show_menu
    print "Enter your choice: "
    choice = gets.chomp

    case choice
    when "1"
        add_book(books)
    
    when "2"
        list_books(books)
    
    when "3"
        list_all_books(books)
    
    when "4"
        delete_book(books)
    
    when "5"
        search_book(books)

    when "6"
        library_summary(books)
    when "7"
        dev_stats(books)
    when "8"
        puts "Goodbye!"
        break
    when "9"
        books_between_years(books)
    when "10"
        update_book_title(books)
    else
        puts "Invalid Choice"
    end
end