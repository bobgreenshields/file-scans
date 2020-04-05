require_relative '../lib/scan_result'
require_relative '../lib/folder'

include FileScans

describe ScanResult do
	describe '#files?' do
		context 'with no files added' do
			it 'returns false' do
				folder = Folder.new(name: 'source', cloudroot: Pathname.pwd + '../fixture',
														target: Pathname.pwd + '../fixture/target' )
				sr = ScanResult.new(folder)
				expect(sr.files?).to be_falsey
			end
		end
		context 'with files added' do
			it 'returns true' do
				folder = Folder.new(name: 'source', cloudroot: Pathname.pwd + '../fixture',
														target: Pathname.pwd + '../fixture/target' )
				sr = ScanResult.new(folder)
				sr.add_file('file.txt')
				expect(sr.files?).to be_truthy
			end
		end
	end

	describe '#new_dirs?' do
		context 'with no new_dirs added' do
			it 'returns false' do
				folder = Folder.new(name: 'source', cloudroot: Pathname.pwd + '../fixture',
														target: Pathname.pwd + '../fixture/target' )
				sr = ScanResult.new(folder)
				expect(sr.new_dirs?).to be_falsey
			end
		end
		context 'with new_dirs added' do
			it 'returns true' do
				folder = Folder.new(name: 'source', cloudroot: Pathname.pwd + '../fixture',
														target: Pathname.pwd + '../fixture/target' )
				sr = ScanResult.new(folder)
				sr.add_new_dir('new_dir')
				expect(sr.new_dirs?).to be_truthy
			end
		end
	end
	
end
