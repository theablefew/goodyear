require "goodyear/version"
require "goodyear/query_methods"

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
