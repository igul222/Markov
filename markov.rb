def train(ttext, chain_size)
  tdata = ttext.split(' ')

  # Hash that supports infinite nesting
  blk = lambda {|h,k| h[k] = Hash.new(&blk)}
  chains = Hash.new(&blk)
  
  for first_word in (0..tdata.count-chain_size)
    for word_chain_pos in (0..chain_size-1)
      
      chains_head = chains
      for chain_pos in (0..word_chain_pos-1)
        chains_head = chains_head[tdata[first_word+chain_pos]]
      end
      chains_head[tdata[first_word+word_chain_pos]] ||= Hash.new(&blk)

    end
  end

  chains
end

def generate(chains, seed, length)
  text = seed.dup

  while text.count < length
    chains_head = chains

    for chain_pos in (0..seed.count-1)
      chains_head = chains_head[text[text.count-seed.count+chain_pos]]
    end

    next_word = chains_head.keys.sample
    if next_word = chains_head.keys.sample
      text << next_word
    else
      return text.join(' ')
    end

  end
  
  text.join(' ')
end

training_text = File.open('training.txt') {|f| f.read }
chain_trees = []
loop do
  print 'Seed: '
  seed = gets.strip.split(' ')
  chain_trees[seed.count+1] ||= train(training_text, seed.count+1)
  puts generate(chain_trees[seed.count+1], seed, 50)
end