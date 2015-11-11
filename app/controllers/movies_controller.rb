class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ["G","PG","PG-13","R"]
    @checked_flag = Hash.new(false)

    if params[:sort]
      session[:sort] = params[:sort]
    end

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if session[:ratings]
      if session[:sort] == "release_date"
        #@movies = Movie.all.order("release_date")
        @movies = Movie.all.order("release_date").where rating:session[:ratings].keys
        session[:ratings].keys.each do |c|
          @checked_flag[c]= true
        end
        @release_date_header = "hilite"
      elsif session[:sort] =="title"
        #@movies = Movie.all.order("title")
        @movies = Movie.all.order("title").where rating:session[:ratings].keys
        session[:ratings].keys.each do |c|
          @checked_flag[c]= true
        end
        @title_header = "hilite"
      else
        #@movies = Movie.all
        @movies = Movie.all.where rating:session[:ratings].keys
        session[:ratings].keys.each do |c|
          @checked_flag[c]= true
        end
      end
    else
      if session[:sort] == "release_date"
        @movies = Movie.all.order("release_date")
        @release_date_header = "hilite"
      elsif session[:sort] =="title"
        @movies = Movie.all.order("title")
        @title_header = "hilite"
      else
        @movies = Movie.all
      end
    end



  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def return
    redirect_to movies_path
  end
end
