module Pruim
  class Color
    def self.rgba(r, g, b, a)
      (a | (b << 8) | (g << 16) | (r << 24))
    end
    
    def self.rgb(r, g, b)
      return rgba(r, g, b, 255)
    end

    # Cpolors are encoded in abgr
    def self.to_rgba(color)
      a = (color)       & 255
      b = (color >> 8)  & 255
      g = (color >> 16) & 255
      r = (color >> 24) & 255
      return r, g, b, a
    end
    
    def self.to_rgb(color)
      r, g, b, a = to_rgba(color)
      return r, g, b
    end
    
    BRIGHT_TRESHOLD = 382

    # Returns true if the color is bright (above threshold)
    # And false if black. Transparency is takeninto account as well.
    def to_bool(treshold = BRIGHT_TRESHOLD)
      
    end
    
  end
end  