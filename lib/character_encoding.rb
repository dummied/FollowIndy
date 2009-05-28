module Windows1252Conversion
  WINDOWS1252_UTF8_MAP = {
    128 => '€',
    130 => '‚',
    131 => 'ƒ',
    132 => '„',
    133 => '…',
    134 => '†',
    135 => '‡',
    136 => 'ˆ',
    137 => '‰',
    138 => 'Š',
    139 => '‹',
    140 => 'Œ',
    142 => 'Ž',
    145 => '‘',
    146 => '’',
    147 => '“',
    148 => '”',
    149 => '•',
    150 => '–',
    151 => '—',
    152 => '˜',
    153 => '™',
    154 => 'š',
    155 => '›',
    156 => 'œ',
    158 => 'ž',
    159 => 'Ÿ'
  }
  
  # Converts a string from Windows-1252 (the stupid encoding used by Word) to
  # UTF-8. Returns a new string.
  def windows1252_to_utf8(check_for_utf8 = true)
    if check_for_utf8
      return dup if isutf8
    end
    
    new_str = ''
    each_char do |ch|
      ch_i = ch[0]
      if (ch_i >= 0x80) && (ch_i <= 0x9f)
        ch = WINDOWS1252_UTF8_MAP[ch_i] || ''
      elsif ch_i & 0x80 != 0
        ch = ch_i.to_utf8
      end
      new_str += ch
    end
    new_str
  end
  
  # In-place version of windows1252_to_utf8.
  def windows1252_to_utf8!
    return if isutf8
    replace(windows1252_to_utf8(false))
  end
end

module UCSCodepoints
  # Returns a UTF8-encoded string containing the character represented by this
  # UCS codepoint.
  def to_utf8
    if self <= 0x7f
      ch = ' '
      ch[0] = self
    elsif self <= 0x7ff
      ch = '  '
      ch[0] = ((self & 0x7c0) >> 6) | 0xc0
      ch[1] = self & 0x3f | 0x80
    elsif self <= 0xffff
      ch = '   '
      ch[0] = ((self & 0xf000) >> 12) | 0xe0
      ch[1] = ((self & 0xfc0) >> 6) | 0x80
      ch[2] = self & 0x3f | 0x80
    else
      ch = '    '
      ch[0] = ((self & 0x1c0000) >> 18) | 0xf0
      ch[1] = ((self & 0x3f000) >> 12) | 0x80
      ch[2] = ((self & 0xfc0) >> 6) | 0x80
      ch[3] = (self & 0x3f) | 0x80
    end
    return ch
  end
end

Fixnum.send(:include, UCSCodepoints)
String.send(:include, Windows1252Conversion)
