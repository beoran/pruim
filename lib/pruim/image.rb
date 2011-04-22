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
    
    def initialize(w, h, palette = nil, make_page = false)
      @w        = w
      @h        = h
      @palette  = palette
      @pages    = [] 
      @ordered  = {} 
      @active   = nil
      self.new_page() if make_page
    end
    
    # Sets the page with the given index as active if it exists.
    def activate(index)
      @active = @pages[index]
    end
    
    # Create a new a page and adds it to this image.
    # The page is also set as the active page.
    def new_page(w = nil, h = nil, frame = 0, layer = 0, data = nil)
      w       ||= self.w
      h       ||= self.h
      page      = Page.new(self, w, h, frame, layer, data)
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
    def getpixel(x, y)
      @active.getpixel!(x, y)
    end
     
  end
end