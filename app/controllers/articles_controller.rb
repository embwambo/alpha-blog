class ArticlesController < ApplicationController

  before_action :set_article_params, only: [:show,:edit,:update,:destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:edit,:update, :destroy]

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:success] = "Article created successfully..."
      redirect_to articles_path
      #redirect_to article_path(@article)
    else
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash[:success] = "Article updated successfully..."
      redirect_to articles_path
    else
      render "edit"
    end
  end

  def destroy
	  @article.destroy
	  flash[:danger] = "Article successfully deleted...."
	  redirect_to articles_path
	end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  private
    def article_params
      params.require(:article).permit(:title, :description)
    end

    def set_article_params
      @article = Article.find(params[:id])
    end

    def require_same_user
      if current_user != @article.user
        flash[:danger] = "You can only edit or delete your own article..."
        redirect_to root_path
      end
    end
end
