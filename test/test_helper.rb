# require 'nanotest'
# require 'redgreen'

require 'pathname'
require 'timeout'

$: << '.'

require 'atto'
include Atto::Test


def test_file(*fname)
  return File.join('test', *fname)
end


$: << '../lib'


