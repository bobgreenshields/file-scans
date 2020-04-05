require_relative '../lib/file_lister'
require_relative '../lib/folder'

include FileScans

describe FileLister do
	describe '#cmd_str' do
		it 'creates a string of the correct cmd' do
			fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
			folder = Folder.new(name: 'test', cloudroot: fixture,
													target: fixture + 'target' )
			lister = FileLister.new(folder)
			expect(lister.cmd_str).to eql "find /home/bobg/dev/file-scans/fixture/target -type f | cut -c 41- | sort > /home/bobg/dev/file-scans/fixture/test.txt"
		end
	end
	describe '#cut_start' do
		it 'returns the length of the target dir plus 1' do
			fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
			folder = Folder.new(name: 'test', cloudroot: fixture,
													target: fixture + 'target' )
			target_dir = '/home/bobg/dev/file-scans/fixture/target'
			expect(folder.target.to_s).to eql target_dir
			lister = FileLister.new(folder)
			expect(lister.cut_start).to eql target_dir.length + 1
		end
	end
	
end
