class TestedUrl < ApplicationRecord
  validates :url, presence: true
  validate :valid_url?
  validates_presence_of :ttfb, :tti, :speed_index, :ttfp
  validates_numericality_of :ttfb, :tti, :speed_index, :ttfp, greater_or_equal_to: 0

  # performs a pagespeed query on the given url and creates a record with the metrics
  # returns true on success
  def self.test_url(url, max_ttfb, max_tti, max_ttfp, max_speed_index)
    result = get_pagespeed_result(url)

    tested_url = TestedUrl.new(url: url)
    
    tested_url.ttfb = result['lighthouseResult']['audits']['time-to-first-byte']['numericValue']
    tested_url.tti = result['lighthouseResult']['audits']['interactive']['numericValue']
    tested_url.ttfp = result['lighthouseResult']['audits']['first-meaningful-paint']['numericValue']
    tested_url.speed_index = result['lighthouseResult']['audits']['speed-index']['numericValue']

    tested_url.passed = tested_url.ttfb <= max_ttfb && tested_url.tti <= max_tti && tested_url.ttfp <= max_ttfp && tested_url.speed_index <= max_speed_index

    tested_url.save!

    tested_url
  end

  # the base fields returned on api request
  def api_response_json
    {
      ttfb: ttfb,
      ttfp: ttfp,
      tti: tti,
      speed_index: speed_index,
      passed: passed
    }
  end

  # base fields and maximum metric values returned on 'last' api request
  def api_response_with_max_json
    api_response_json.merge({
      max_ttfb: max_ttfb,
      max_tti: max_tti,
      max_speed_index: max_speed_index,
      max_ttfp: max_ttfp
    })
  end

  def max_ttfb
    self.class.where(url: url).maximum(:ttfb)
  end

  def max_ttfp
    self.class.where(url: url).maximum(:ttfp)
  end

  def max_tti
    self.class.where(url: url).maximum(:tti)
  end

  def max_speed_index
    self.class.where(url: url).maximum(:speed_index)
  end

  private

  def valid_url?
    uri = URI.parse(url)
    errors.add(:url, 'invalid') unless uri.is_a? URI::HTTP
  rescue => e
    errors.add(:url, 'invalid')
  end

  # fetches pagespeed result and returns it as a Hash from the parsed JSON
  def self.get_pagespeed_result(url)
    uri = URI('https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=' + url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    response = http.request(Net::HTTP::Get.new(uri.request_uri))

    JSON.parse(response.body)
  end
end