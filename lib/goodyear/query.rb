module Goodyear
  class Query
    def initialize(q,f,s, sort, highlights, facets)
      @q = q || []
      @f = f || []
      @s = s || []
      @sort = sort
      @highlights = highlights
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

    def highlights
      @highlights
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
