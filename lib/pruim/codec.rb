module Pruim
  module Codec
    
    def self.register(name, klass)
      @codecs     ||= {} 
      @codecs[name] = klass
    end
    
    # Returns a codec based on it's short name.
    def self.for_name(name)
      return Pruim.const_get(name.upcase) 
    end
    
    # Returns the codec to use for the given filename, based on the extension
    def self.for_filename(filename)
      ext = File.extname(flename) # get filename extension
      return self.codec_for(name)
    end
    
    # Returns an instance of codec to use for the given filename, based on the 
    # extension of the filename.
    def self.new_for_filename(filename)
      codec = for_filename(filename)
      return codec.new()
    end
    
    # Returns a new instance of a codec based on it's short name.
    def self.new_for_name(name)
      codec = for_name(name)
      return nil unless codec
      return codec.new()
    end
    
    # Returns a codec based on it's short name or on the filename's extension.
    def self.for_filename_name(filename, codecname = nil)
      codec = nil      
      return for_name(codecname) if codecname
      return for_filename(codecname)
    end
    
    # Returns a new instance of a codec based on it's short name or on 
    # the filename's extension.
    def self.new_for_filename_name(filename, codecname = nil)
      codec = for_filename_name(filename, codecname)
      return nil unless codec
      return codec.new()
    end
  
    # Stream should be an StringIO, or otherwise IO compatible object.
    def decode(io)
      raise "not implemented"
    end
    
    def encode(image, io)
      raise "not implemented"
    end
    
    def can_decode?(io)
      raise "not implemented"
    end
    
    def can_encode?(image)
      raise "not implemented"
    end
    
    def encode_will_degrade?(image)
      raise "not implemented"
    end
    
    def text
      return "A codec that does nothing."
    end
  end
end