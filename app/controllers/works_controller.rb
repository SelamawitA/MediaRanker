class WorksController < ApplicationController
  before_action :find_user

  def index
    @works = Work.all
  end

  def new
    @work = Work.new
  end

  def edit
    @work = Work.find_by(id: params[:id])
  end

  def create
    @work = Work.new
    @work.category = params[:work][:category]
    @work.title = params[:work][:title]
    @work.creator = params[:work][:creator]
    @work.publication_year = params[:work][:publication_year]
    if @work.save
      redirect_to work_path(@work.id)
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
    else
      render :new
    end
  end

  def update
    @work = Work.find_by(id: params[:id])
    @work.category = params[:work][:category]
    @work.title = params[:work][:title]
    @work.creator = params[:work][:creator]
    @work.publication_year = params[:work][:publication_year]
    @work.description = params[:work][:description]
    if @work.save
      redirect_to work_path(@work.id)
      flash[:success] = "Successfully Updated #{@work.category} #{@work.id}"
    else
      render :edit
    end

  end


  def show
    @work = Work.find_by(id: params[:id])
  end


  def destroy
    @work = Work.find_by(id: params[:id])
    if @work
      @work.votes.each do |vote|
        vote.destroy
      end
      @work.destroy
      flash[:success] = "Your selection was successfully destroyed."
      redirect_to works_path
    else
      render :show
      flash[:error] = "Your selection has already been removed."
    end
  end

  def upvote
    @work = Work.find_by(id: params[:work])

      if @work && session[:user_id] != nil
        vote = Vote.create(user_id:@username.id,work_id:@work.id)
          if vote.errors.any?
            flash[:fail] = "You've already voted for this work."
          else
              flash[:success] = "Successfully upvoted!"
          end
      else
        flash[:fail] = "You must be logged in to vote."
      end
        redirect_to works_path
  end


  private
  def work_params
    params.require(:work).permit(:category,:title,:creator,:publication_year,:description)
  end
end
