require 'nokogiri'
require 'open-uri'
require 'csv'

class Publicacion
  attr_accessor :usuario , :texto
  def initialize(usuario, texto)
    @usuario = usuario
    @texto = texto
  end
end
  
class Extractor
  def initialize(scraper, filename="elements.csv")

    @scraper = scraper
    @url = scraper.url
    @list_xpath = scraper.list_xpath
    
    @children_css= scraper.children_css
    
    @target_tags= JSON.parse(scraper.target_tags)
    
    @filename=filename
    rescue JSON::ParserError => e
    puts "Error parsing JSON: #{e.message}"
    @target_tags = {}
    puts "FINISHED INITIALIZING"
  end
  
  def extract
    children_css = @children_css
    selectors = @target_tags
    results= []
    pagina = URI.open(@url).read
    paginaHTML = Nokogiri::HTML(pagina)
    @scraper.raw_html = paginaHTML
    contenedor = paginaHTML.xpath(@list_xpath)
    values={}
    selectors.each_key do |key|
      values[key] = ""
    end
    
    puts "CONENTEDOR #{contenedor}"
    contenedor.css(children_css).each do |element|
      selectors.each do |label, css_selector|
        # Extraer el valor usando el selector CSS y agregarlo al array correspondiente en el hash
        extracted_value = element.css(css_selector).text().strip() 
        values[label] << extracted_value unless extracted_value.empty?
        values[label] << "Unknown" if extracted_value.empty?
      end
      results.append(values)
      values = {}
      selectors.each_key do |key|
        values[key] = ""
      end 
    end
  
    return results
  end

  
  def offline_extract
    if @scraper.raw_html.nil? || @scraper.raw_html.empty?
      puts "Raw HTML is empty. Calling extract() to populate raw_html."
      return extract() 
    end
    children_css = @children_css
    selectors = @target_tags
    results= []
    pagina = @scraper.raw_html
    paginaHTML = Nokogiri::HTML(pagina)
    contenedor = paginaHTML.xpath(@list_xpath)
    values={}
    selectors.each_key do |key|
      values[key] = ""
    end
    
    puts "offline extract #{contenedor}"
    contenedor.css(children_css).each do |element|
      selectors.each do |label, css_selector|
        # Extraer el valor usando el selector CSS y agregarlo al array correspondiente en el hash
        extracted_value = element.css(css_selector).text().strip() 
        values[label] << extracted_value unless extracted_value.empty?
        values[label] << "Unknown" if extracted_value.empty?
      end
      results.append(values)
      values = {}
      selectors.each_key do |key|
        values[key] = ""
      end 
    end
  
    return results
  end

  def guardar(elements)
    return if elements.empty?
  
    headers = elements.first.keys
  
    CSV.open("extraction_results/"+ @filename, 'w', write_headers: true, headers: headers) do |csv|
      elements.each do |element|
        csv << headers.map { |header| element[header] }
      end
    end
  end
end

# url = "https://x.com/search?q=venezuela&src=typed_query"
# selector_css = ".css-175oi2r" 

# extractor = Extractor.new(url, selector_css)
# publicaciones = extractor.extraer

# if publicaciones.empty?
#   puts "No se encontraron publicaciones."
# else
#   publicaciones.each do |publicacion|
#     puts "Usuario: #{publicacion.usuario} - Texto: #{publicacion.texto}"
#   end
# end

