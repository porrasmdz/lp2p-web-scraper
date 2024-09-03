
class NewsExtractor < Extractor
  def initialize(scraper)
    super(scraper, "noticias.csv")
  end
end
