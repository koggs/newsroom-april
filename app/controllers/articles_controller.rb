class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]
  before_action :load_categories, except: [:show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:notice] = "Article successfully saved and sent for approval"
      redirect_to root_path
    else
      flash[:alert] = @article.errors.full_messages.first
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      flash[:notice] = "Article successfully saved and sent for approval"
      redirect_to article_path(@article)
    else
      flash[:alert] = @article.errors.full_messages.first
      render 'edit'
    end
  end

  def search
    ArticleIndex.import
    query = ArticleIndex.query(match: {headline: params[:search]})
    @hits = query.hits
    @articles = query.objects
    render :search
  end

  private
  def article_params
    params.require(:article).permit(:headline, :content, :category_id)
  end

  def load_categories
    @categories = Category.all
  end
end
