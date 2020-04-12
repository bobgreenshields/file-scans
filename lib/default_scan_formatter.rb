
module FileScans
	class DefaultScanFormatter
		def call(scan_result)
			result = []
			result += new_dirs(scan_result)
			result += files(scan_result)
			result += duplicates(scan_result)
			result += ["\n"]
			result.join("\n")
		end

		def files(scan_result)
			case scan_result.files.count
			when 0
				["\nThere are no files to move"]
			when 1
				result = ["\nThere is one file"]
				result += scan_result.files.map(&:to_s)
				result << "\n"
			else
				result = ["\nThere are #{scan_result.files.count} files"]
				result += scan_result.files.map(&:to_s)
			end
		end

		def new_dirs(scan_result)
			case scan_result.new_dirs.count
			when 0
				["\nThere are no new dirs to create"]
			when 1
				result = ["\nThere is one new dir"]
				result += scan_result.new_dirs.map(&:to_s)
				# result << "To create"
			else
				result = ["\nThere are #{scan_result.new_dirs.count} new dirs"]
				result += scan_result.new_dirs.map(&:to_s)
				# result << "To create"
			end
		end

		def duplicates(scan_result)
			case scan_result.duplicates.count
			when 0
				["\nThere are no duplicated file names"]
			when 1
				result = ["\nThere is one filename which already exists in the target dir"]
				result += scan_result.duplicates.map(&:to_s)
			else
				result = ["\nThere are #{scan_result.duplicates.count} filenames which already exist in the target dir"]
				result += scan_result.duplicates.map(&:to_s)
			end
		end

	end
	
end
