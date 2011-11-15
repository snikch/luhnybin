class String
  def luhn?
    return false if self == ''
    self.to_s.split(//).reverse.each_with_index.map{|n,i|i.odd? ? n.to_i*2 : n }.join.split(//).map(&:to_i).inject(:+) % 10 == 0
  end
end

def check input
  input.gsub(/([0-9\- ]+)/) do |match|
    numeric = match.gsub(/[\- ]+/,'')
    if numeric.length >= 14 && numeric.length <= 16 && numeric.luhn?
      match = match.gsub(/[0-9]/,'X')
    else
      mask_matrix = []
      combinations(match).each do |combination|
        index = 0;
        if combination.gsub(/[\- ]+/,'').luhn?
          while index = match.index(combination, index+1)
            matrice = [index, index + combination.length]
            mask_matrix << matrice
          end
        end
      end
      mask_matrix.each do |point|
        match[point[0], point[1] - point[0]] = "X" * (point[1] - point[0])
      end
    end
    match
  end
end

def combinations input
  c, i = [], 0
  input.to_s.split(//).each do |char|
    c = c + c.dup.last(i).map{|e| e.dup + char.dup } if i > 0
    if char =~ /\d/
      c.push char.dup
      i += 1
    end
  end
  c.reject{ |x| x.length < 14 || x.length > 16 }
end

while inp = STDIN.gets
  puts check(inp)
  STDOUT.flush
end
