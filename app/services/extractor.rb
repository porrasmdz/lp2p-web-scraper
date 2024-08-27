class ScraperController < ApplicationController
    def index
    end
  end
  
  class Publicacion
    attr_accessor :usuario , :texto
    def initialize(usuario, texto)
      @usuario = usuario
      @texto = texto
    end
  end
    
  class Extractor
    def initialize(url, selectorCss)
      @url = url
      @selectorCss = selectorCss
    end
    
    def extraer()
      publicaciones= []
      pagina = URI.open(@url).read
      paginaHTML = Nokogiri::HTML(pagina)
      paginaHTML.css(@selectorCss).each do |publicacion|
        texto= publicacion.css('css-1jxf684 r-bcqeeo r-1ttztb7 r-qvutc0 r-poiln3').text.strip()
        usuario= publicacion.css('css-146c3p1 r-bcqeeo r-1ttztb7 r-qvutc0 r-37j5jr r-a023e6 r-rjixqe r-b88u0q r-1awozwy r-6koalj r-1udh08x r-3s2u2q').text.strip()
        publicaciones.push(Publicacion.new(usuario, texto))
      end
    
      return publicaciones
    end
  
    def guardar(publicaciones)
      publicaciones.each do |publicacion|
      archivo= CSV.open('publicaciones.csv', 'a')
      archivo << [publicacion]
      end
    end
  end
  
  url = "https://x.com/search?q=venezuela&src=typed_query"
  selector_css = ".css-175oi2r" 
  
  extractor = Extractor.new(url, selector_css)
  publicaciones = extractor.extraer
  
  if publicaciones.empty?
    puts "No se encontraron publicaciones."
  else
    publicaciones.each do |publicacion|
      puts "Usuario: #{publicacion.usuario} - Texto: #{publicacion.texto}"
    end
  end
  