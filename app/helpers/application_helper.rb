module ApplicationHelper
  def read_from_cache link
    item = {}
    Rails.cache.fetch("#{link}") do
      # craw image save into array
      images = []
      doc = Nokogiri::HTML(URI.open(link))
      doc.xpath("//img/@src").each do |src|
        value = if src.value.include?("http")
          src.value
        else
          URI.join(link, src.value).to_s
        end

        images << value
      end
      # craw content
      source = open(link).read
      new_readability = Readability::Document.new(source, :tags => %w[body], :remove_empty_nodes => false)
      item[link] = {content: handle_content(new_readability)}
      item[link].merge! short_description: handle_short_description(new_readability)
      item[link].merge! images: images
      item
    end
  end

  def handle_load_image content, link
    url = URI.join(link, '/').to_s
    content.gsub(/<img src="\//, '<img src="'+url)
  end

  def handle_short_description new_readability
    new_readability.options = {:retry_length=>250, :min_text_length=>25, :remove_unlikely_candidates=>true, :weight_classes=>true, :clean_conditionally=>true, :remove_empty_nodes=>false, :min_image_width=>130, :min_image_height=>80, :ignore_image_format=>[], :blacklist=>nil, :whitelist=>nil, :tags=>["div", "p"], :encoding=>"UTF-8"}
    new_readability.content.gsub(/[<div>|<p>]/, '').truncate(200, separator: ' ')
  end

  def handle_content new_readability
    new_readability.options = {:retry_length=>250, :min_text_length=>25, :remove_unlikely_candidates=>true, :weight_classes=>true, :clean_conditionally=>true, :remove_empty_nodes=>false, :min_image_width=>130, :min_image_height=>80, :ignore_image_format=>[], :blacklist=>nil, :whitelist=>nil, :tags=>["div", "p", "img", "a"], :attributes => ["src", "alt", "href"], :encoding=>"UTF-8"}
    new_readability.content.dump
  end
end
