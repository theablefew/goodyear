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
end
