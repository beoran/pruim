require 'test_helper'
require 'pruim'

test_w, test_h = 64, 32

assert { Pruim }
assert { Pruim::Image } 
image = Pruim::Image.new(test_w, test_h, :pages => 1)
assert { image } 
assert { image.w == test_w }
assert { image.h == test_h }
red   = Pruim::Color.rgb(255,  0,  0)
green = Pruim::Color.rgb(0  ,255, 255)
blue  = Pruim::Color.rgb(0  ,  0, 255)
page  = image.active
assert { page } 
assert { page.w == test_w }
assert { page.h == test_h }
page.fill(red)
page.putpixel(1, 1, green)
page.putpixel(10, 10, blue)
assert { image.getpixel(1, 1)   == green }
assert { image.getpixel(10, 10) == blue  }
assert { image.getpixel(0, 0)   == red   }





