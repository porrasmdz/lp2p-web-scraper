require 'uri'
require 'net/http'

class TwitterExtractor < Extractor
  def initialize(scraper)
    super(scraper, "linkedin.csv")
  end

  def offline_extract
    puts "EVAL RESULT "
    if @scraper.raw_html.nil? || @scraper.raw_html.empty?
      puts "Raw HTML is empty. Calling extract() to populate raw_html."
      return extract() 
    else 
      doc = Nokogiri::HTML(@scraper.raw_html)

      json_text = doc.at('body p').text
      selectors = @target_tags
      begin
        json_data = JSON.parse(json_text)
        return json_data  
        rescue JSON::ParserError => e
          puts "Error parsing JSON: #{e.message}"
      end
    end
    return []
  end
  
end

