class CountriesController < ApplicationController
  layout 'static'

  def index
	  @countries = Country.order(:name)
	  @categories = CountryCategory.all
	end

  def show
    @country = Country.friendly.find(params[:id])
    @hotels = @country.hotels

    resort_ids = Resort.
      where(country_id: @country.id).
      joins(:resort_dates).
      where('EXTRACT(MONTH FROM resort_dates.season_end) >= ? AND EXTRACT(MONTH FROM resort_dates.season_start) <= ?', Time.now.strftime('%m'), Time.now.strftime('%m')).
      order('resorts.name').
      pluck(:id)

    @resorts = Resort.
      where(country_id: @country.id, id: resort_ids).
      includes(:hotels).
      includes(:resort_dates).
      paginate(page: 1, per_page: 5)

    @min_prices = {}

    @hotels.
      where(resort_id: @resorts.map(&:id)).
      joins(:search_results).
      select('hotels.resort_id, search_results.min_price').
      where('search_results.min_price > 0.01').
      order(:min_price).
      each do |res|
        @min_prices[res['resort_id'].to_i] ||= res['min_price'].to_i
      end

    @popular_resorts = @hotels.
      select('DISTINCT ON (name) resorts.name, hotels.hotel_rate').
      where('hotels.hotel_rate > 0.01').
      order('resorts.name, hotels.hotel_rate DESC').
      limit(20)

    @resorts_without_season = @country.
      resorts.
      joins(:resort_dates).
      includes(:hotels).
      includes(:resort_dates).
      where('resorts.id NOT IN (?)', resort_ids).
      where('EXTRACT(MONTH FROM resort_dates.season_start) > ?', Time.now.strftime('%m')).
      order(:name)

    @weather = Rails.cache.fetch(params, expires_in: 3.hours) do
      hotels = (@resorts_without_season + @resorts).map(&:hotels).uniq

      Weather.new(@hotels).call
    end

    render layout: false
  end

  def resort_items
    populate

    @weather = Rails.cache.fetch(params, expires_in: 3.hours) do
      hotels = @resorts.map(&:hotels).uniq

      Weather.new(@hotels).call
    end

    render partial: 'resort_items', layout: false
  end

  def show_region
  	@categories = CountryCategory.all
    @category = CountryCategory.friendly.find(params[:id])
  	@countries = @category.countries
  end

  private

  def populate
    @country = Country.friendly.find(params[:id])

    @resorts = Resort.
      where(country_id: @country.id).
      joins(:resort_dates).
      includes(:hotels).
      includes(:resort_dates).
      where('EXTRACT(MONTH FROM resort_dates.season_end) >= ? AND EXTRACT(MONTH FROM resort_dates.season_start) <= ?', Time.now.strftime('%m'), Time.now.strftime('%m')).
      order('resorts.name').
      paginate(page: params[:page], per_page: 5)

    @min_prices = {}

    Hotel.
      where(resort_id: @resorts.map(&:id)).
      joins(:search_results).
      select('hotels.resort_id, search_results.min_price').
      where('search_results.min_price > 0.01').
      order(:min_price).
      each do |res|
        @min_prices[res['resort_id'].to_i] ||= res['min_price'].to_i
      end
  end
end
