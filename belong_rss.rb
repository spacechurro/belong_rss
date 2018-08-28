require 'nokogiri'
require 'open-uri'
require 'rss'
require 'sinatra'

get '/', provides: 'html' do
  erb :index
  
end

get '/feed' do
  content_type "text/xml"
  doc = Nokogiri::HTML(open("https://belong.io"))

  rss = RSS::Maker.make("atom") do |maker|
    maker.channel.author = "belong rss - a makeshift rss feed for belong.io"
    maker.channel.updated = Time.now.to_s
    maker.channel.title = "rss for belong.io"
    maker.channel.id = "belong rss"

    doc.css('div.item').each do |list_item|
      link = list_item.xpath("./a").first.remove
      summary = list_item.inner_html.gsub(/^[\s]+/,'').gsub('"','')

      unless link['href'] =~ /^\/\?when/
        maker.items.new_item do |item|
          item.link = link['href']
          item.title = link.content
          item.summary = summary
          item.updated = Time.now.to_s
        end
      end
    end
  end
  rss.to_s
end

