class NewService
  class << self
    require 'nokogiri'
    require 'open-uri'
    include ApplicationHelper
    def lasted_best_news
      doc = Nokogiri::HTML(URI.open('https://news.ycombinator.com/best'))
      convert_content_to_items doc
    end

    def detail_item link
      result = read_from_cache link
      result[link]
    end

    private

    def convert_content_to_items doc
      items = {}
      doc.css('table.itemlist tbody tr.athing', 'td.title:last-child').each do |item|
        element = item.at_css(('a.storylink[href]'))
        items[element['href']] = element.content if element.present?
      end
      crawler = CrawlerService.new(items.keys)
      results = crawler.run

      results.each do |k, v|
        results[k].merge! title: items[k]
      end
      results = items.map{|k, v| [k, {title: v, short_description: '', images: []}]}.to_h if results.blank?
      results
    end
  end
end