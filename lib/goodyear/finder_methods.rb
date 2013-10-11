module Goodyear
  module FinderMethods
    def where(*query)
      @_and ||= []
      serialize_arguments(query)
      return self
    end

    def fields(*f)
      @_fields ||= []
      @_fields = f.collect(&:to_s)
      return self
    end

    def size(size)
      @_size ||= []
      @_size = size
      return self
    end

    def sort(*sort_order)
      @_sort = sort_order
      return self
    end
    def first
      self.size(1) #maybe more performant?
      self.fetch.first
    end

    private 
    def serialize_arguments(q)
      q.each do |arg|
        arg.each_pair { |k,v|  @_and << "#{k}:#{v}" } if arg.class == Hash
        @_and << arg if arg.class == String
      end
    end

  end
end
