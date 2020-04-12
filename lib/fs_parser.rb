require 'optparse'

module FileScans
	class FSParser
		def initialize
			@options = Set.new
			make_opt_parser
		end

		def make_opt_parser
			@opt_parser = OptionParser.new do | opts |
				opts.on '-d', '--dirs', 'Make the empty directory structure' do @options << :build_dirs end
				opts.on '-f', '--files', 'Make the file list text files' do @options << :files end
				opts.on '-s', '--scan', 'Scan the directories for files and new dirs' do @options << :scan end
				opts.on '-m', '--move', 'Scan the dirs, move files and make new dirs' do @options << :move end
				opts.on '-h', '--help', 'Prints this help' do puts @opt_parser; exit end
			end
			@opt_parser.banner = 'Usage: filescans [options]'
		end

		def call(arg_array)
			@opt_parser.parse(arg_array)
			@options
		end
		
	end
	
end
