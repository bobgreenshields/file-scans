module FileScans
	class ScanResult
		def initialize(folder)
			@folder = folder
			@new_dirs = []
			@files = []
			@duplicates = []
			@new_dirs_dirty = false
			@files_dirty = false
			@duplicates_dirty = false
		end

		def add_file(file)
			@files << file
			@files_dirty = true
			self
		end

		def add_new_dir(dir)
			@new_dirs << dir
			@new_dirs_dirty = true
			self
		end

		def add_duplicate(duplicate)
			@duplicates << duplicate
			@duplicates_dirty = true
			self
		end

		def new_dirs
			@new_dirs.sort! if @new_dirs_dirty
			@new_dirs_dirty = false
			return enum_for(:new_dirs) unless block_given?
			@new_dirs.each { |item| yield item}
		end

		def new_dirs?
			@new_dirs.length > 0
		end

		def files
			@files.sort! if @files_dirty
			@files_dirty = false
			return enum_for(:files) unless block_given?
			@files.each { |item| yield item}
		end

		def files?
			@files.length > 0
		end

		def duplicates
			@duplicates.sort! if @duplicates_dirty
			@duplicates_dirty = false
			return enum_for(:duplicates) unless block_given?
			@duplicates.each { |item| yield item}
		end

		def duplicates?
			@duplicates.length > 0
		end

		def name
			@folder.name
		end

		def path
			@folder.path
		end

		def target
			@folder.target
		end
	end
end
