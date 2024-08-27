class Api::V1::ScrapersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_scraper, only: [:show, :update, :destroy]
  def index
    @scrapers = Scraper.all
    render json: @scrapers
  end

  def show
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
    if @scraper.update(params.permit(:name, :url))
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
    params.require(:scraper).permit(:name, :url)
  end
end
