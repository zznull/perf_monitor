class TestedUrlsController < ApplicationController
  # returns all tested_url records for the given url
  def index
    render json: TestedUrl.where(url: params[:url]).map(&:api_response_json)
  end

  # returns the last tested_url for the given url and maximum metrics for that url
  def last
    tested_url = TestedUrl.where(url: params[:url]).order(created_at: :desc).first
    if tested_url.present?
      render json: tested_url.api_response_with_max_json
    else
      render nothing: true, status: 404
    end
  end

  # queries pagespeed for the given url and stores the teted_url in the database, returns the created record on success
  def create
    if create_params_valid?
      tested_url = TestedUrl.test_url(params[:url], params[:max_ttfb].to_f, params[:max_tti].to_f, params[:max_ttfp].to_f, params[:max_speed_index].to_f)
      
      if tested_url.persisted?
        render json: tested_url.api_response_json
      else
        render json: tested_url.errors, status: 422
      end
    else
      render json: { error: "Mandatory parameters: url, max_ttfb, max_tti, max_ttfp, max_speed_index" }, status: 422
    end
  end

  private

  # checks if all input parameters for the create action are present
  def create_params_valid?
    params[:url].present? && params[:max_ttfb].present? && params[:max_tti].present? && params[:max_ttfp].present? && params[:max_speed_index].present?
  end
end