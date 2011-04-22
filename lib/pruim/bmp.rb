require 'bindata'

module Pruim
  class BMP < Codec
    class Header < BinData::Record
      endian :little
      string :magic, :length => 2
      uint32 :filesize
      uint16 :creator1
      uint16 :creator2
      uint32 :bitmap_offset
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
    
    class CoreHeader < BinData::Record
      endian :little
      uint32 :header_size
      int32  :width
      int32  :height
      uint16 :nplanes
      uint16 :bitspp
    end
          
    class ColorTableEntryRGBX < BinData::Record
      uint8 :r
      uint8 :g
      uint8 :b
      uint8 :x
    end
    
    class ColorTableRGBX < BinData::Record
      array :type => ColorTableEntryRGBX
    end
      
    def can_decode?(io)
      header = Header.read(io)
      io.rewind
      return header && header.magic == 'BM'
    end
    
    def decode_bpp8(io, header, core, extra)
      table =[] 
      for i in 0..255 
        table << ColorTableRGBX.read(io)
      end
      p table  
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
       
      p header, core, extra
    end
    
    
    
    
    
  end
end  


