module Goodyear
  module FilterMethods
    def filter(name, options = {}, &block)
      @_filters ||= []
      @_filters << {name: name, args: options, l: block}
      return self
    end

    def has_field?(field)
      filter :exists, {field: field}
      return self
    end
  end
end
