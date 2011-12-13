 module Pruim
  # A Page can represents both a layer and a frame of animation, for 
  # multi-page image formats.
  # Inside a Page, bitmap data is stored in an array as follows:
  # For a monochrome image, true and false are stored, where true is "black"
  # meaning pixel activated, on, say, an LCD screen, and false means white
  # or pixel not activated.
  # For :palette mode images, what is stored are palette indexes.
  # for an RBGA , integers are stored that encode the color in an 8888 bits
  # ABGR way
  class Page
    attr_reader :image
    attr_reader :w
    attr_reader :h
    attr_reader :layer
    attr_reader :frame
    attr_reader :x
    attr_reader :y
 
    # Extra information data hash table.
    attr_reader :info
    
    # Returns a row of pixels with the given y coordinates as an array
    def row(y)
      return @data.slice(y * self.w, self.w)
    end
    
    
    def pixels
      return @data
    end

    def initialize(image, w, h, extra = {})
      @image  = image
      @info   = {}
      @w      = w
      @h      = h
      @frame  = extra[:frame] || 0
      @layer  = extra[:layer] || 0
      @x      = extra[:x] || 0
      @y      = extra[:y] || 0
      @data   = extra[:data]
      if !@data
        @data = Array.new(@h * @w, 0)
      end
    end

    # Returns true if the coordinates are outside of the limits of this page.
    def outside?(x, y)
      return true   if (x  < 0 ) || (y  < 0 ) 
      return true   if (x >= @w) || (y >= @h)
      return false
    end

    # Gets the pixel at coordinates x,y.  Returns nil if out of bounds. 
    def getpixel!(x, y)
      @data[y * @w + x]
    end

    # Gets the pixel at coordinates x,y. Returns nil if out of bounds. 
    def getpixel(x, y)      
      return getpixel!(x, y)    
    end    
    
    def putpixel!(x, y, color)
      @data[y * @w + x] = color
    end
    
    def putpixel(x, y, color)
      return nil if outside?(x, y)
      putpixel!(x, y, color)
    end
    
    def fill(color)
      for i in (0..(@h*@w))
        @data[i] = color
      end
    end
    
    
  end
end