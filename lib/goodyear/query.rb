module Goodyear
  class Query
    def initialize(q,f,s, sort, highlights, facets, filters, query_filters)
      @q = q || []
      @f = f || []
      @s = s || []
      @sort = sort || []
      @highlights = highlights || []
      @facets = facets
      @filters = filters
      @query_filters = query_filters || []
    end

    def facets
      @facets || []
    end

    def filters
      @filters || []
    end

    def query
      @q
    end

    def fields
      @f
    end

    def highlights
      @highlights
    end

    def size
      @s
    end

    def sort
      @sort
    end

    def query_filters
     @query_filters
    end


    private


  end
end
