require 'pathname'
require_relative 'dir_explorer'

module FileScans
	class Scanner

		def initialize(root, target)
			@root = Pathname.new(root)
			@target = Pathname.new(target)
			@files = []
			@new_dirs = []
			on_file = ->(file, context) { context.add_file(file) }
			on_dir = ->(dir, context) { context.add_dir_if_new(dir) }
			@explorer = DirExplorer.new(on_file: on_file, on_dir: on_dir, context: self)
		end

		def add_file(file)
			@files << file.relative_path_from(@root).to_s
		end

		def add_dir_if_new(dir)
			dir_str = dir.relative_path_from(@root).to_s
			@new_dirs << dir_str unless (@target + dir_str).directory?
		end

		def scan
			@explorer.call(@root)
			@files = @files.sort
			@new_dirs = @new_dirs.sort
		end

		def new_dirs
			return enum_for(:new_dirs) unless block_given?
			@new_dirs.each { |item| yield item}
		end

		def files
			return enum_for(:files) unless block_given?
			@files.each { |item| yield item}
		end
	end
end
