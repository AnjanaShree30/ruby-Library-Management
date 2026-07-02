module Exportable
  def to_csv_row
    fields = [@title, @author, @year, @genre]
    fields.map { |field| "\"#{field}\"" }.join(",")
  end
end