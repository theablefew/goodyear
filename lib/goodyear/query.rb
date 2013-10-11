module Goodyear
  class Query
    def initialize(q,f,s, sort)
      @q = q || []
      @f = f || []
      @s = s || []
      @sort = sort
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
  end
end
