class Api::V1::ScrapersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_scraper, only: [:show, :update, :destroy, :scrape]
  def index
    @scrapers = Scraper.all
    render json: @scrapers
  end
  
  def scrape
    scraper = Scraper.find(params[:id])
    exttype = params[:type] || 'default'
    extractor = "ads"
    exttype = exttype.to_str.strip
    
    if exttype =="linkedin"
      puts "ejecutando de tipo linkedin"
      extractor = LinkedinExtractor.new(scraper)
    elsif exttype=="noticias"
      extractor = NewsExtractor.new(scraper)
    
    else "default"
      puts "fallback IS #{exttype}"
      extractor = Extractor.new(scraper)
      
    end
    result = extractor.offline_extract()
    extractor.guardar(result)
    if scraper.update(result: result)
      render json: { message: "Scraping completed successfully", result: scraper.result }, status: :ok
    else
      render json: { error: "Failed to save scraping result" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Scraper not found" }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def scrape_online
    scraper = Scraper.find(params[:id])
    type = params[:type] || 'default'
    extractor = case type
    when 'linkedin'
      LinkedinExtractor.new(scraper)
    when 'noticias'
      NewsExtractor.new(scraper)
    else
      Extractor.new(scraper)
    end
    result = extractor.extract()
    extractor.guardar(result)
    if scraper.update(result: result)
      render json: { message: "Scraping completed successfully", result: scraper.result }, status: :ok
    else
      render json: { error: "Failed to save scraping result" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Scraper not found" }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    
    scraper = Scraper.find(params[:id])
    
    render json: @scraper
    
  end

  def create
    @scraper = Scraper.new(params.permit(:name, :url))
    if @scraper.save
      render json: @scraper, status: :created
    else
      render json: @scraper.errors, status: :unprocessable_entity
    end
  end

  def update

    @scraper = Scraper.find(params[:id])
    if @scraper.update(params.permit(:id, :name, :url, :list_xpath, :children_css, :target_tags))
      render json: @scraper
    else
      render json: @scraper.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @scraper.destroy
    head :no_content
  end

  private

  def set_scraper
    @scraper = Scraper.find(params[:id])
  end

  def scraper_params
    params.require(:scraper).permit(:name, :url, :list_xpath, :children_css, :target_tags)
  end
end
