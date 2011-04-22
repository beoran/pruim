module Pruim
  class Palette < Array
  
    def new_rgb(r, g, b)
      self << Pruim::Color.rgb(r, g, b)
      return self.size - 1
    end
    
    def new_rgba(r, g, b, a)
      self << Pruim::Color.rgba(r, g, b, a)
      return self.size - 1
    end
    
    
    
  end
end