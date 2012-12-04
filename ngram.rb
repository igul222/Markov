def rand_from_weighted_hash hash
  total_weight = hash.inject(0) { |sum,(v,weight)| sum+weight }
  running_weight = 0
  n = rand*total_weight
  hash.each do |v,weight|
    return v if n > running_weight && n <= running_weight+weight
    running_weight += weight
  end
end

def load(data)
  blk = lambda {|h,k| h[k] = Hash.new(&blk)}
  ngrams = Hash.new(&blk)

  data.each_line do |line|
    line = line.split("\t")
    ngrams[line[1]][line[2]][line[3]][line[4].strip] = line[0].to_i
  end

  ngrams
end

def generate(ngrams, seed)
  text = seed.split(' ')
  loop do
    options = ngrams[text[text.count-3]][text[text.count-2]][text[text.count-1]]
    if options != {}
      text << rand_from_weighted_hash(options)
    else
      return text.join(' ')
    end
  end
end

data = File.open('w4.txt').read
ngrams = load(data)
loop do
  print 'Seed: '
  seed = gets.strip
  50.times do
    puts generate(ngrams, seed)
  end
end