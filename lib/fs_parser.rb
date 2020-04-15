require 'optparse'
require 'set'

module FileScans
	class FSParser
		def initialize
			@options = Set.new
			make_opt_parser
		end

		def make_opt_parser
			@opt_parser = OptionParser.new do | opts |
				opts.on '-d', '--dirs', 'Sync the directory structures' do @options << :sync_dirs end
				opts.on '-r', '--rebuild-dirs', 'Delete and rebuild the directory structure' do @options << :rebuild_dirs end
				opts.on '-f', '--files', 'Make the file list text files' do @options << :files end
				opts.on '-s', '--scan', 'Scan the cloud dirs for files and new dirs' do @options << :scan end
				opts.on '-m', '--move', 'Scan the cloud dirs, move files and make new dirs' do @options << :move end
				opts.on '-l', '--list', 'List all of the settings from the config file' do @options << :list_settings end
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
