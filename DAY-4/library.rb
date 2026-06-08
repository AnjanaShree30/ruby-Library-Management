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
end

def add_book(books)
    print "enter title:"
    title = gets.chomp

    print "enter author:"
    author = gets.chomp

    print "enter year:"
    year = gets.chomp

    print "enter genre:"
    genre = gets.chomp
    books.push({
        title:title,
        author:author,
        year:year,
        genre:genre
    })
end

def list_books(books)
    books.first(3).each_with_index do |book,index|
            puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]}"
    end
end

def list_all_books(books)
    books.each_with_index do |book,index|
            puts "#{index+1}.#{book[:title]} by #{book[:author]} was published in #{book[:year]}"
    end
end

def delete_book(books)
    print "enter title to delete book:"
    title = gets.chomp

    book_found=books.any? do |book|
        book[:title].downcase == title.downcase
    end

    if !book_found
        puts "book not found!"
    else
        books.reject! do |book|
            book[:title].downcase == title.downcase
        end
        puts "book deleted"
    end
end

def search_book(books)
    print "enter title to search for a book:"
    title = gets.chomp

    found_book = books.find do |book|
        book[:title].downcase == title.downcase
    end

    if found_book.empty?
        puts "book bot found"
    else
        puts "title: #{found_book[:title]}"
        puts "author: #{found_book[:author]}"
        puts "year: #{found_book[:year]}"
        puts "genre: #{found_book[:genre]}"
    end
end

def library_summary(books)

    if books.empty?
        puts "Library is empty"
    else
        total_books = books.length

        most_recent_book = books.last

        oldest_book = books.min_by do |book|
            book[:year]
        end

        puts "total books: #{total_books}"
        puts "most recent book: #{most_recent_book[:title]} by #{most_recent_book[:author]} was published in #{most_recent_book[:year]} and belongs to genre #{most_recent_book[:genre]}"
        puts "oldest book: #{oldest_book[:title]} (#{oldest_book[:year]})"
    end
end

def dev_stats(books)
    total_books=books.count
    puts "total books: #{total_books}"

    books_after_2000=books.count do |book|
        book[:year].to_i > 2000
    end
    puts "books after 2000: #{books_after_2000}"

    authors=books.map do |book|
        book[:author]
    end.uniq

    puts "authors:\n"
    authors.each do |author|
        puts "#{author}"
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
    else
        puts "Invalid Choice"
    end
end