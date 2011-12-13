module Pruim
  class Palette < Array

    # Adds a new RGB color to this palette. Returns the palette index.
    def new_rgb(r, g, b)
      self << Pruim::Color.rgb(r, g, b)
      return self.size - 1
    end

    # Adds a new RGBA color to this palette. Returns the palette index.
    def new_rgba(r, g, b, a)
      self << Pruim::Color.rgba(r, g, b, a)
      return self.size - 1
    end    
    
  end
end