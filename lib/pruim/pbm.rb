# Tiny PBM parser, only works for 2 color (monochrome) pbm's
# 
module Pruim
  # Tiny PBM parser integrated with Prium codecs.
  class PBM
    include Codec
    Codec.register('pbm', self)
    
    # Read in a pbm file from an io object.
    def decode(stream)
      header    = stream.gets
      lines     = []
      until stream.eof?
        lines << stream.gets
      end
      data      = []
      image   = nil
      page    = nil
      w, h    = nil, nil
      y       = 0
      comment = ''
      lines.each do |line|
        if line[0] == '#'
          comment << line.chomp.sub(/\A#/, '')
          next
        end
        if !w
          w , h = line.chomp.split(' ').map { |v| v.to_i }
          next
        end
        # Converts 1 to true, rest to false.
        bits = line.chomp.split('').map { |v| (v == '1') }
        data += bits
      end
      image = Image.new(w, h, :mode => :monochrome, :data => data)
      image.comment = comment
      return image
    end

    def encode(image, stream)
      stream.puts("P1")
      stream.puts("##{image.comment}") if image.comment
      stream.puts("#{image.w} #{image.h}")
      page = image.pages.first
      for y in (0...page.h) do
        for x in (0...page.w) do
          white   = page.getpixel!(x, y)
          stream.write(white ? '1' : '0')
        end
        stream.puts()
      end
    end

    def can_decode?(stream)
      header = stream.gets
      stream.rewind
      return header == "P1\n"
    end
    
    # Can only encode monocrome images.
    def can_encode?(image)      
      return image.mode == :monochrome
    end

    # Will only save first page of image.
    def encode_will_degrade?(image)
      return (image.pages.size > 1)
    end
  end # class PBM
end # module Pruim
