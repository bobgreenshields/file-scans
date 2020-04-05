require 'pathname'

module FileScans
	class Folder
		attr_reader :name, :target, :files_list

		def initialize(name: , cloudroot: , target: )
			@name = name
			@cloudroot = Pathname.new(cloudroot).expand_path
			@target = Pathname.new(target).expand_path
		end

		def path
			@cloudroot + name
		end

		def files_list
			@cloudroot + "#{name}.txt"
		end
		
	end
	
end
