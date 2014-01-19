require 'goodyear/query'
require 'goodyear/finder_methods'
require 'goodyear/facet_methods'
require 'goodyear/filter_methods'
require 'goodyear/boolean_methods'
require 'goodyear/query_cache'
require 'goodyear/enumerable'

module Goodyear
  module QueryMethods
    include Goodyear::FinderMethods
    include Goodyear::BooleanMethods
    include Goodyear::FacetMethods
    include Goodyear::FilterMethods
    include Goodyear::QueryCache

    def fetch
      es = self.perform
      options = {wrapper: self, type: document_type}
      options.merge!( @_search_options ) unless @_search_options.nil?

      @_search_options = nil

      tire = Tire::Search::Search.new(self.index_name, options)
      tire.query { string es.query } unless es.query.blank?
      tire.sort{ by *es.sort } unless es.sort.blank?
      tire.size( es.size ) unless es.size.nil?
      tire.fields( es.fields ) unless es.fields.empty?
      tire.highlight( es.highlights ) unless es.highlights.empty?

      es.filters.each do |f|
        tire.filter(f[:name], f[:args], &f[:l])
      end

      es.facets.each do |f|
        tire.facet(f[:name], f[:args], &f[:l] )
      end

      cache_query(tire.to_curl) { tire.version(true).results }

    end

    def perform
      construct_query
      esq = Query.new(@_query, @_fields, @_size, @_sort, @_highlights, @_facets, @_filters)
      clean
      return esq
    end

    def search_options(options)
      @_search_options = options
      self
    end

    def search_type(type)
      @_search_options ||= {}
      @_search_options.merge! search_type: type
      self
    end

    def count
      search_type 'count'
      fetch.total
    end

    def routing(r)
      @_search_options ||= {}
      @_search_options.merge! routing: r
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

    def reset_query
      clean
    end

    private

    def clean
      @_fields = []
      @_and    = []
      @_size   =  nil
      @_sort   = []
      @_or     = []
      @_facets = []
      @_filters = []
      @_highlights = []
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
