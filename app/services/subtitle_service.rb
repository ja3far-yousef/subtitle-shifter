
class SubtitleService
  def self.shift(content, milliseconds)
    lines = content.split("\n")
    lines.each_with_index do |line, index|
        pieces = line.split(' ')
        if pieces.include?('-->')
          pieces[0] = convert_to_standard_form([0, convert_to_milliseconds(pieces[0]) + milliseconds].max)
          pieces[2] = convert_to_standard_form([0, convert_to_milliseconds(pieces[2]) + milliseconds].max)
        end
        lines[index] = pieces.join(' ')
    end
    return lines.join("\n")
  end
  def self.convert_to_milliseconds(time)
    seconds = 3600
    milliseconds = 0
    for i in 0..2 do
      milliseconds += (time[i * 3].to_i * 10 + time[i * 3 + 1].to_i) * seconds
      seconds /= 60
    end
    milliseconds *= 1000
    milliseconds += time[9].to_i * 100 + time[10].to_i * 10 + time[11].to_i
    return milliseconds 
end
  def self.convert_to_standard_form(milliseconds)
    hours = milliseconds / (1000 * 3600)
    minutes = (milliseconds / (1000 * 60)) % 60
    seconds = (milliseconds / 1000) % 60
    milliseconds %= 1000
    return format("%02d:%02d:%02d,%03d",
      hours,
      minutes,
      seconds,
      milliseconds
    )
  end
  
end