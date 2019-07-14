class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.create!(category_params)
    redirect_to(session[:intended_url])
    session[:intended_url] = nil
  end

  def edit
  end

  private 

  def category_params
    params.require(:category).
    permit(:name)
  end
end
