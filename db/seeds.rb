require 'json'
require 'open-uri'

url = 'https://tmdb.lewagon.com/movie/top_rated'
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)

puts 'Deleting movies'
Movie.destroy_all

puts 'Creating movies from Movies API...'

movies['results'].each do |movie|
  new_movie = Movie.create(
    title: movie['title'],
    overview: movie['overview'],
    poster_url: "https://image.tmdb.org/t/p/original/#{movie['poster_path']}",
    rating: movie['vote_average']
  )
  puts "Movie #{new_movie.title} was created"
end

puts 'All done!'
