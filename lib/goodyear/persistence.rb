module Goodyear
  module Persistence
    def initialize(attrs={})
      puts attrs
        attrs.each do |attr, value|
            # call Tire's property method if it hasn't been set explicitly
            self.class.property attr unless self.class.property_types.keys.include? attr
            # set instance variable
            instance_variable_set("@#{attr}", value) 
        end
        super attrs
    end
  end
end
