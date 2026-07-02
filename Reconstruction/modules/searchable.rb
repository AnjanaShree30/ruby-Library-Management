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