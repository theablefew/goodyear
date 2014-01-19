require 'goodyear/railtie' if defined?(Rails)
require "goodyear/version"
require "goodyear/query_methods"
require 'goodyear/persistence'

module Goodyear
  module ElasticQuery

      def self.included(base)
        base.extend(Goodyear::QueryMethods)
      end

      def escape_id
        id.gsub('-','\\-')
      end
  end

  def self.cache
    original_cache_value = Rails.application.config.goodyear_perform_caching
    Rails.application.config.goodyear_perform_caching = true
    lm = yield
    Rails.application.config.goodyear_perform_caching = original_cache_value
    lm
  end
end
