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
    
    @movies = Movie.all
    
    @ratings = params[:ratings] || session[:ratings] || [] # if no params[:ratings] then assign empty array
    
   
    
    @ll_ratings = Movie.ratings
    
    if params[:ratings].present?
      
      puts @filtered_ratings
      puts "sample text"
      @movies = @movies.where(rating: @ratings.keys) 
      session[:ratings] = params[:ratings]
     
    end
    
    @title_css = " "
    @release_date_css = " "
    
    @sortby = params[:sort] || session[:sort] || ""
      
      if @sortby == "title"
        @movies = @movies.order(@sortby)
        session[:sort] = "title"
        @sort = "title"
        @title_css = "hilite"
      
      elsif @sortby == "release_date"
        @movies = @movies.order(@sortby)
        @sort = "release_date"
        session[:sort] = "release_date"
        @release_date_css = "hilite"
      end
      
      if (!params.has_key?(:ratings) && session[:ratings].present? ) || (!params.has_key?(:sortby) && session[:sortby].present?)
        flash.keep
        redirect_to movies_path(:sort => session[:sortby], :ratings => session[:ratings])
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

end
