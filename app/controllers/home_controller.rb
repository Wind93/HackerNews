class HomeController < ApplicationController
  def index
    @items = NewService.lasted_best_news
  end
end