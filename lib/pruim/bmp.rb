require 'bindata'

module Pruim
  class BMP
    include Codec
    
    class Header < BinData::Record
      endian :little
      string :magic, :length => 2
      uint32 :filesize
      uint16 :creator1
      uint16 :creator2
      uint32 :bitmap_offset
      def set(*args)
        self.magic, self.filesize, self.creator1, self.creator2, 
        self.bitmap_offset = *args
        self
      end
    end

    class CoreHeader < BinData::Record
      endian :little
      uint32 :header_size
      int32  :width
      int32  :height
      uint16 :nplanes
      uint16 :bitspp
      def set(*args)
        self.header_size, self.width, self.height, self.nplanes, 
        self.bitspp = *args
        self
      end
    end

    class ExtraHeader < BinData::Record
      endian :little
#       uint32 :header_size
#       int32  :width
#       int32  :height
#       uint16 :nplanes
#       uint16 :bitspp
      uint32 :compress_type
      uint32 :bmp_bytesz
      int32  :hres
      int32  :vres
      uint32 :ncolors
      uint32 :nimpcolors
      
      def set(*args) 
        self.compress_type, self.bmp_bytesz, self.hres, self.vres, self.ncolors,
        self.nimpcolors  = *args
        self
      end
    end

    BI_RGB   = 0        # 
    BI_RLE8  = 1        # RLE 8-bit/pixel   Can be used only with 8-bit/pixel bitmaps
    BI_RLE4  = 2        # RLE 4-bit/pixel   Can be used only with 4-bit/pixel bitmaps
    BI_BITFIELDS  = 3   # Bit field or Huffman 1D compression for BITMAPCOREHEADER2   
    BI_JPEG       = 4   # JPEG or RLE-24 compression for BITMAPCOREHEADER2  
    BI_PNG        = 5   # PNG  The bitmap contains a PNG image.
    BITMAPINFOHEADER=40 # Commonly used
    BITMAPV5HEADER  =124# Latest version
    HEADER_SIZE     = 14
    
          
    class BGRX < BinData::Record
      uint8 :b
      uint8 :g
      uint8 :r
      uint8 :x
      def set(b, g, r, x)
        self.b = b
        self.g = g
        self.r = r
        self.x = x
        self
      end
    end
    
    class BGR < BinData::Record
      uint8 :b
      uint8 :g
      uint8 :r
      
      def set(b, g, r)        
        self.b = b
        self.g = g
        self.r = r
        self
      end
    end
    
    class ColorTableRGBX < BinData::Record
      array :type => BGRX
    end
      
    def can_decode?(io)
      header = Header.read(io)
      io.rewind
      return header && header.magic == 'BM'
    end
    
    
    def read_palette(io, header, core, extra)
      palette = Pruim::Palette.new
      ncolors = 2 ** core.bitspp
      for i in 0..255
        color = BGRX.read(io)
        palette.new_rgb(color.r, color.g, color.b)
        raise "Unexpected end of file whilst reading bmp palette!" if io.eof?
      end
      return palette
    end
    
    
    def decode_bpp8_rgb(io, header, core, extra, padding)
      data = []
      for ypos in (0...core.height) 
        size = core.width + padding
        # read a line with padding
        raise "End of file when reading BMP btyes!" if io.eof?
        str  = io.read(size)
        raise "Short read when reading BMP bytes!" unless str && str.bytesize == size
        # make an array out of it and drop the padding
        arr  = str.bytes.to_a
        arr.pop(padding)
        data = arr + data # prepend data
      end      
      return data
    end
    
    # Calculate padding size
    def calc_padding(wide, palette = true)
      bs      = palette ? 1 : 3
      padding = (1 * bs * wide) % 4;
      padding = 4 - padding if padding != 0
      return padding
    end

    
    def decode_bpp8(io, header, core, extra)
      # p header, core, extra
      io.seek(HEADER_SIZE + core.header_size)      
      palette = read_palette(io, header, core, extra)
      # Skip to the bitmap, gap may be there...
      io.seek(header.bitmap_offset)
      # Calculate padding size
      padding = calc_padding(core.width, true)
      data    = nil
      case extra.compress_type
        when BI_RGB
          data = decode_bpp8_rgb(io, header, core, extra, padding)
        else
          return nil
      end
      image   = Image.new(core.width, core.height, :depth => core.bitspp, 
                        :palette => palette, :pages => 1, :data => [data])
      return image
    end
    
    def decode(io)
      header = Header.read(io)
      core   = CoreHeader.read(io)
      extra  = nil
      if (core.header_size == BITMAPINFOHEADER)
        extra = ExtraHeader.read(io)
      end
      io.seek(HEADER_SIZE + core.header_size)
      # skip rest of header that we don't support
      if core.bitspp == 8
        return decode_bpp8(io, header, core, extra)
      end
      # TODO: real color bitmaps.
      return nil
    end
    
    def encode_palette(image, io)
      image.palette.each do |color|
        r, g, b = *Color.to_rgb(color)
        bgrx    = BGRX.new.set(b, g, r, 0)
        bgrx.write(io)
      end
    end
    
    def encode_bpp8_rgb(image, io, padding)
      page = image.active
      ypos = image.h - 1
      while ypos >= 0
        row   = page.row(ypos)
        row   = row + [0] * padding
        str   = row.pack('C*')
        io.write(str)
        ypos -= 1
      end
    end
    
    
    def encode_bpp8(image, io, padding)
      encode_palette(image, io)
      encode_bpp8_rgb(image, io, padding)
    end
    
    def encode_bpp24(image, io, padding)
    end
    
    def encode(image, io)
      bitcount    = (image.palette? ? 8 : 24)
      bitmap_size = ((image.w * bitcount) / 8) * image.h
      info_size   = BITMAPINFOHEADER
      # Data for the palette
      if image.palette?
        info_size += image.palette.size * 4
      end
      total_size = 14 + info_size + bitmap_size
      # write bmp header info 
      header = Header.new.set('BM', total_size, 0, 0, 14 + info_size)
      header.write(io)
      core   = CoreHeader.new.set(BITMAPINFOHEADER, image.w, image.h, 1, bitcount)
      core.write(io)
      extra  = ExtraHeader.new.set(BI_RGB, 0, 0, bitcount, image.palette.size, 0)
      extra.write(io)
      # Calculate padding size
      padding = calc_padding(image.active.w, image.palette?)
      if image.palette?
        encode_bpp8(image, io, padding)
      else
        encode_bpp24(image, io, padding)
      end
      return image
    end
    
    
    
  end
end  


