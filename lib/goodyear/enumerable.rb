module Goodyear
  module Enumerable
     def each &block
        fetch.results.each do |result|
          if block_given?
            block.call result
          else
            yield result
          end
        end
      end

     def collect &block
       fetch.results.collect do |result|
         if block_given? 
           block.call result
         else
           yield result
         end
       end
     end
  end
end
