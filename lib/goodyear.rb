require 'goodyear/railtie' if defined?(Rails)
require "goodyear/version"
require "goodyear/query_methods"
require 'goodyear/persistence'

module Goodyear
  mattr_accessor :force_cache
  @@force_cache = false

  module ElasticQuery

      def self.included(base)
        base.extend(Goodyear::QueryMethods)
      end

      def escape_id
        id.gsub('-','\\-')
      end
  end

  def self.cache
    Goodyear.force_cache = true
    lm = yield
    Goodyear.force_cache = false
    lm
  end
end

