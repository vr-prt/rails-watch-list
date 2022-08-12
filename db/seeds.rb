require 'json'
require 'open-uri'

url = 'https://tmdb.lewagon.com/movie/top_rated'
movies_serialized = URI.open(url).read
movies = JSON.parse(movies_serialized)

puts 'Deleting all'
Bookmark.destroy_all
List.destroy_all
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

puts 'Creating lists...'

lists = [
  List.create(name: 'Classics'),
  List.create(name: 'Drama'),
  List.create(name: 'Action')
]

lists_images_urls = ['app/assets/images/alex-litvin-MAYsdoYpGuk-unsplash.jpg', 'app/assets/images/felix-mooneeram-evlkOfkQ5rE-unsplash.jpg', 'app/assets/images/mason-kimbarovsky-X_d7m2r70bA-unsplash.jpg']
lists_images = []

lists_images_urls.each do |url|
  file = URI.open(url)
  lists_images << file
end

lists[0].image.attach(io: lists_images[0], filename: 'classic.png', content_type: 'image/png')
lists[1].image.attach(io: lists_images[1], filename: 'drama.png', content_type: 'image/png')
lists[2].image.attach(io: lists_images[2], filename: 'action.png', content_type: 'image/png')

lists.each do |list|
  puts "#{list.name} created"
  4.times do
    movie = Movie.all.sample
    bookmark = Bookmark.new(comment: 'Sample comment')
    bookmark.movie = movie
    bookmark.list = list
    bookmark.save
    puts "#{bookmark.movie.title} was linked to #{list.name}"
  end
end

puts 'All done!'
