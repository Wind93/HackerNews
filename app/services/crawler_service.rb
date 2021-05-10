class CrawlerService
  require 'open-uri'
  require 'readability'
  include ApplicationHelper

  private
    attr_reader :links

  public

  def initialize links
    @links = links
    @crawled = []
    @mutex = Mutex.new
    @results = {}
  end

  def run
    length_thread = links.length/6
    workers = (0...length_thread).map do
      Thread.new do
        # these code will execute by each thread
        while link = next_link
          begin
            page_analyze(link)
          rescue OpenURI::HTTPError, SocketError
            next
          end
          
          # push_link(doc)
        end
      end
    end
  
    workers.map(&:join)
    @results
  end

  def page_analyze(link)
    item = read_from_cache(link)
    @results.merge! item
  end

  def push_link(doc)
    doc.xpath("//a/@href").each do |url|
      current_url = url.value
      @links.push(current_url) if insertable?(current_url)
    end
  end

  def next_link
    link = nil
    @mutex.synchronize do
      link = @links.shift
      @crawled.push(link) if link
    end

    link
  end
end
