 module Pruim
  class Page
    attr_reader :image
    attr_reader :w
    attr_reader :h
    attr_reader :layer
    attr_reader :frame
    attr_reader :x
    attr_reader :y
    
    def initialize(image, w, h, frame = 0, layer = 0, data = nil)
      @image  = image
      @w      = w
      @h      = h
      @frame  = frame
      @layer  = layer
      @x      = 0
      @y      = 0
      @data   = data
      if !@data
        @data = Array.new(@h * @w, 0)
      end
    end
    
    def outside?(x, y)
      return true   if (x  < 0 ) || (y  < 0 ) 
      return true   if (x >= @w) || (y >= @h)
      return false
    end
    
    def getpixel!(x, y)
      @data[y * @w + x]
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