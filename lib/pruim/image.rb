module Pruim
  # An image consists of one or more pages.
  # Whether a page is a layer, a frame in an animation
  # or both, is determined by the properties of the page. 
    
  class Image
    
    attr_reader :w
    attr_reader :h
    attr_reader :palette
    attr_reader :pages
    # Currently "active" page.
    attr_reader :active
    # image mode, may be one of :palette, :rgba
    attr_reader :mode
    # color depth, may be one of 1, 2, 4, 8, 16, 24, 32
    attr_reader :depth
    
    # Extra information data hash table.
    attr_reader :info
    
    def self.depth_for_colors(ncolors)
      (Math.log(ncolors) / Math.log(2)).to_i
    end
    
    def initialize(w, h, extra = {})
      @w        = w
      @h        = h
      @info     = {}
      @palette  = extra[:palette]
      @mode     = extra[:mode]      
      @mode   ||= (@palette ? :palette : :rgba)
      @palette  = Palette.new if !@palette && @mode == :palette
      @depth    = extra[:depth]
      @depth  ||= (@palette ? 8 : 32)
      @pages    = [] 
      @ordered  = {} 
      @active   = nil
      if extra[:pages]
        data = extra[:data] || []
        extra[:pages].times { |i| self.new_page(@w, @h, :data => data[i]) }
      end  
    end
    
    def palette?
      return !(@palette.nil?)
    end
      
    
    # Sets the page with the given index as active if it exists.
    def activate(index)
      @active = @pages[index]
    end
    
    # Create a new a page and adds it to this image.
    # The page is also set as the active page.
    def new_page(w = nil, h = nil, extra = {})
      w       ||= self.w
      h       ||= self.h
      page      = Page.new(self, w, h, extra)
      return self.add_page(page)
    end
    
    # Adds a page to this image. The page is also set as the active page. 
    def add_page(page)
      @pages << page
      @ordered[page.frame]             = {} unless @ordered[page.frame]
      @ordered[page.frame][page.layer] = [] unless @ordered[page.frame][page.layer] 
      @ordered[page.frame][page.layer] << page
      @active = page
      return page
    end
    
    # Returns an array of all pages at the given frame and layer 
    def pages_at(frame = 0, layer = 0)
      @ordered[frame, layer]
    end
    
    # Gets a pixel from the current active page, if any.
    def getpixel(x, y)
      @active.getpixel!(x, y)
    end
    
    # Sets a pixel to the current active page, if any.
    def putpixel(x, y, color)
      @active.putpixel!(x, y, color)
    end

    # Fills the current active page, if any.
    def fill(color)
      @active.fill(color)
    end

     
  end
end