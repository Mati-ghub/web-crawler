require 'mechanize'
require 'csv'

class Movie < Struct.new(:title, :rating)
end

movies = []

agent = Mechanize.new

main_page = agent.get "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
list_page = main_page
rows = list_page.root.css(".lister-list tr")

rows.take(10).each do |row|
	title = row.at_css(".titleColumn a").text.strip
	rating = row.at_css(".ratingColumn strong").text.strip

	movie = Movie.new(title, rating)
	movies << movie
end

CSV.open("top7.csv", "w", col_sep: ";") do |csv|
	csv << ["Tytuł", "Ocena"]
	movies.each do |movie|
		csv << [movie.title, movie.rating]
	end
end