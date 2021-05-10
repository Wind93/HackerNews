class HomeController < ApplicationController
  def index
    @items = NewService.lasted_best_news
  end

  def detail
    @item = NewService.detail_item params[:href]
  end
end