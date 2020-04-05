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

	describe '#files' do
		context 'with files added' do
			it 'enumerates a sorted list of the added files' do
				folder = Folder.new(name: 'source', cloudroot: Pathname.pwd + '../fixture',
														target: Pathname.pwd + '../fixture/target' )
				sr = ScanResult.new(folder)
				sr.add_file('file2.txt')
				sr.add_file('file1.txt')
				sr.add_file('file3.txt')
				expected = %w(file1.txt file2.txt file3.txt)
				result = sr.files.inject([]) {|arr, file| arr << file}
				expect(result).to eql expected
			end
		end
	end

	describe '#new_dirs' do
		context 'with new_dirs added' do
			it 'enumerates a sorted list of the added new_dirs' do
				folder = Folder.new(name: 'source', cloudroot: Pathname.pwd + '../fixture',
														target: Pathname.pwd + '../fixture/target' )
				sr = ScanResult.new(folder)
				sr.add_new_dir('dir2')
				sr.add_new_dir('dir1')
				sr.add_new_dir('dir3')
				expected = %w(dir1 dir2 dir3)
				result = sr.new_dirs.inject([]) {|arr, new_dir| arr << new_dir}
				expect(result).to eql expected
			end
		end
	end
	
end
