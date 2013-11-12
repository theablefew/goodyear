module Goodyear
  module FacetMethods
    def facet(name, options = {}, &block)
      @_facets ||= []
      @_facets << {name: name, args: options, l: block}
      return self
    end
  end
end
