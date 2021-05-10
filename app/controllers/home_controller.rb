class HomeController < ApplicationController
  def index
    target_link = "https://news.ycombinator.com/best?p=#{params[:page] || 1}"
    @current_page = params[:page].to_i || 1
    @items = NewService.lasted_best_news(target_link)
  end

  def detail
    @item = NewService.detail_item params[:href]
  end
end