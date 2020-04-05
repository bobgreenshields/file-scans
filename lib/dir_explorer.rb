module Filer2
	class DirExplorer

		def initialize(on_file: ->(file, context) {}, on_dir: ->(dir, context) {}, recursive: true, context: nil)
			@on_file = on_file
			@on_dir = on_dir
			@recursive = recursive
			@context = context
		end

		def clone
			self.class.new(on_file: @on_file, on_dir: @on_dir, recursive: @recursive, context: @context)
		end

		def call(root)
			root.each_child do |child|
				if child.directory?
					@on_dir.call(child, @context)
					self.clone.call(child) if @recursive
				elsif child.file?
					@on_file.call(child, @context)
				else
				end
			end
		end	

	end
end
