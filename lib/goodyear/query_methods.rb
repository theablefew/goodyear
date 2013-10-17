require 'goodyear/query'
require 'goodyear/finder_methods'
require 'goodyear/facet_methods'
require 'goodyear/boolean_methods'

module Goodyear
  module QueryMethods

    include Goodyear::FinderMethods
    include Goodyear::BooleanMethods
    include Goodyear::FacetMethods

    def fetch
      es = self.perform
      self.search do |s|
        s.query do |q|
          q.string es.query
        end

        s.sort{ by *es.sort } unless es.sort.nil?
        s.size es.size unless es.size.nil?
        s.fields es.fields unless es.fields.empty?
      end
    end

    def perform
      construct_query
      esq = Query.new(@_query, @_fields, @_size, @_sort) and clean
      return esq
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
      @_size   = []
      @_or     = []
      @query_segments = []
    end

    def construct_query
      @query_segments << @_and
      @_query = @query_segments.collect{ |segment| segment.join(" AND ") }.join(" OR ")
    end

  end
end
