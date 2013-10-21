module Goodyear
  module BooleanMethods
    def or
      self.add_query_segment
      return self
    end
  end
end
