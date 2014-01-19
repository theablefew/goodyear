module Goodyear
  class Query
    def initialize(q,f,s, sort, highlights, facets, filters)
      @q = q || []
      @f = f || []
      @s = s || []
      @sort = sort || []
      @highlights = highlights || []
      @facets = facets
      @filters = filters
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

  end
end
