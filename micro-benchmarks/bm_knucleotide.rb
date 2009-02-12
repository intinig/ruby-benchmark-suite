# The Computer Language Shootout
# http://shootout.alioth.debian.org
#
# contributed by jose fco. gonzalez
# modified by Sokolov Yura
# Adapted for the Ruby Benchmark Suite.
require File.dirname(__FILE__) + '/../lib/benchutils'

label = File.expand_path(__FILE__).sub(File.expand_path("..") + "/", "")
iterations = ARGV[-3].to_i
timeout = ARGV[-2].to_i
report = ARGV.last

def frecuency(seq, length)
  n, table = seq.length - length + 1, Hash.new(0)
  f, i = nil, nil
  (0 ... length).each do |f|
      (f ... n).step(length) do |i|
          table[seq[i,length]] += 1
      end
  end
  [n,table]
end

def sort_by_freq(seq, length)
  n,table = frecuency(seq, length)
  a, b, v = nil, nil, nil
  table.sort{|a,b| b[1] <=> a[1]}.each do |v|
      puts "%s %.3f" % [v[0].upcase,((v[1]*100).to_f/n)]
  end
    puts
end

def find_seq(seq, s)
  n,table = frecuency(seq, s.length)
  puts "#{table[s].to_s}\t#{s.upcase}"
end

benchmark = BenchmarkRunner.new(label, iterations, timeout)
benchmark.run do
  seq = String.new
  fname = File.dirname(__FILE__) + "/fasta.input" 
  File.open(fname, "r").each_line do |line|
    seq << line.chomp
  end
  [1,2].each {|i| sort_by_freq(seq, i) }
  %w(ggt ggta ggtatt ggtattttaatt ggtattttaatttatagt).each{|s| find_seq(seq, s) }
end
  
File.open(report, "a") {|f| f.puts "#{benchmark.to_s},n/a" }
