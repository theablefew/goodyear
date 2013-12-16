module Goodyear
  module FinderMethods
    def where(*query)
      serialize_arguments(query)
      return self
    end

    def fields(*f)
      @_fields ||= []
      @_fields = f.collect(&:to_s)
      return self
    end

    def size(size)
      @_size = size
      return self
    end

    def sort(*sort_order)
      @_sort = sort_order
      return self
    end
    alias :order :sort

    def highlight(fields)
      @_highlights = fields
      return self
    end

    def first
      self.size(1) #maybe more performant?
      self.fetch.first
    end

    def last
      self.size(1).sort(created_at: :desc).fetch.last
    end

    def all
      self.size(9999).fetch
    end

    protected
    def add_query_segment
      @query_segments ||= []
      @query_segments << @_and
      @_and = []
    end

    private
    def serialize_arguments(q)
      @_and ||= []
      q.each do |arg|
        arg.each_pair { |k,v|  @_and << "#{k}:#{v}" } if arg.class == Hash
        @_and << arg if arg.class == String
      end
    end


  end
end
