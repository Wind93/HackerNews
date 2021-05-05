class NewService
  require 'rubygems'
  require 'readability'
  require 'nokogiri'
  require 'open-uri'
  class << self
    def lasted_best_news
      doc = Nokogiri::HTML(URI.open('https://news.ycombinator.com/best'))
      convert_content_to_items doc
    end

    private

    def convert_content_to_items doc
      items = {}

      doc.css('table.itemlist tbody tr.athing', 'td.title:last-child').each do |item|
        element = item.at_css(('a.storylink[href]'))
        items[element['href']] = element.content if element.present?
      end
      items
    end

    def content_item href
      source = open(href).read
      Readability::Document.new(source).content
    end
  end
end