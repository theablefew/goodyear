require 'goodyear/query'
require 'goodyear/finder_methods'
require 'goodyear/facet_methods'
require 'goodyear/boolean_methods'
require 'goodyear/query_cache'

module Goodyear
  module QueryMethods

    include Goodyear::FinderMethods
    include Goodyear::BooleanMethods
    include Goodyear::FacetMethods
    include Goodyear::QueryCache

    def fetch
      es = self.perform
      cache_query(es.cache_key) {
        options = {wrapper: self, type: document_type}
        puts "Search: #{@_search_options}".color :red
        options.merge!( @_search_options ) unless @_search_options.nil?

        tire = Tire::Search::Search.new(self.index_name, options)
        tire.query { string es.query } unless es.query.blank?
        tire.sort{ by *es.sort } unless es.sort.nil?
        tire.size( es.size ) unless es.size.nil?
        tire.fields( es.fields ) unless es.fields.empty?
        es.facets.each do |f|
          tire.facet(f[:name], f[:args], &f[:l] )
        end

        ActiveSupport::Notifications.instrument "query.elasticsearch", name: self.name, query: tire.to_curl do
          tire.version(true).results
        end
      }
    end

    def perform
      construct_query
      esq = Query.new(@_query, @_fields, @_size, @_sort, @_facets)
      clean
      return esq
    end

    def search_options(options)
      @_search_options = options
      self
    end

    def scope(name, scope_options = {})
      name = name.to_sym

      scope_proc = lambda do |*args|
        options = scope_options.respond_to?(:call) ? scope_options.call(*args) : scope_options
      end

      singleton_class.send(:define_method, name, &scope_proc)
    end

    alias :to_query :perform

    private

    def clean
      @_fields = []
      @_and    = []
      @_size   =  nil
      @_or     = []
      @_facets = []
      @query_segments = []
    end

    def construct_query
      @query_segments ||= []
      @query_segments << @_and
      @_query = @query_segments.collect do |segment| 
        next if segment.nil?
        segment.uniq.join(" AND ")
      end.join(" OR ")
    end

  end
end
