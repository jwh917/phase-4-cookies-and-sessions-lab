class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActiveRecord::NotAuthorized, with: :max_views
  # Rails doesn't seem to have an exception to :unauthorized

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1

    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    else 
      max_views
    end
    
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def max_views
    render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
  end

end
