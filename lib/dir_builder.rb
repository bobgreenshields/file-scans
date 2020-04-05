require 'pathname'
require_relative 'dir_explorer'


module FileScans
	class DirBuilder
		def initialize(folder)
			@folder = folder
			on_dir = ->(dir, context) { context.add_dir(dir) }
			@explorer = DirExplorer.new(on_dir: on_dir, context: self)
		end

		def add_dir(dir)
			dir_str = dir.relative_path_from(@folder.target).to_s
			(@folder.path + dir_str).mkpath
		end

		def call
			@folder.path.mkdir
			@explorer.call(@folder.target)
		end
		
	end
	
end
