module Goodyear
  class Query
    def initialize(q,f,s, sort, facets)
      @q = q || []
      @f = f || []
      @s = s || []
      @sort = sort
      @facets = facets
    end

    def facets
      @facets || []
    end

    def query
      @q
    end

    def fields
      @f
    end

    def size
      @s
    end

    def sort
      @sort
    end

    def cache_key
      Digest::SHA256.new.hexdigest("#{query}#{fields}#{sort}#{size}")
    end
  end
end
