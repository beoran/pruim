 module Pruim
  class Movie
    attr_reader :w
    attr_reader :h
    attr_reader :frames

    def initialize(w, h, index = 0, nframes = 1, nlayers = 1, data = nil)
      @w      = w
      @h      = h
      @frames = Array.new(nframes) do | index |
        Movie.new(self, w, h, index, nlayers, data)
      end 
    end
  end
end