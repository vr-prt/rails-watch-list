class BookmarksController < ApplicationController
  before_action :set_list, only: %i[list new create delete]

  def new
    @bookmark = Bookmark.new
  end

  def create
    @movie = Movie.find(params[:bookmark][:movie_id])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    @bookmark.movie = @movie
    @bookmark.save
    redirect_to list_path(@list)
  end

  def destroy
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def bookmark_params
    params.require(:bookmark).permit(:comment)
  end
end
