require_relative '../lib/scan_result'
require_relative '../lib/default_scan_formatter'
require_relative '../lib/folder'

include FileScans

describe DefaultScanFormatter do
	describe '#files' do
		let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
		let(:folder) do
			Folder.new(name: 'test', cloudroot: fixture, target: fixture + 'target' )
		end
		let(:formatter) { DefaultScanFormatter.new }
		context 'with no files' do
			it 'returns an array with the correct string' do
				sr = ScanResult.new(folder)
				expect(formatter.files(sr)).to eql ["\nThere are no files to move", "\n"]
			end
		end
		context 'with one file' do
			it 'returns the single file string and the file name' do
				sr = ScanResult.new(folder)
				sr.add_file('/mnt/target/file1.txt')
				expect(formatter.files(sr)).to eql ["\nThere is one file", "/mnt/target/file1.txt", "\n"]
			end
		end
		context 'with 3 files' do
			it 'returns the correct number in the string with the files' do
				sr = ScanResult.new(folder)
				sr.add_file('/mnt/target/file1.txt')
				sr.add_file('/mnt/target/file2.txt')
				sr.add_file('/mnt/target/file3.txt')
				expected = ["\nThere are 3 files", "/mnt/target/file1.txt",
								"/mnt/target/file2.txt", "/mnt/target/file3.txt", "\n"]
				expect(formatter.files(sr)).to eql expected
			end
		end

		describe '#new_dirs' do
			let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
			let(:folder) do
				Folder.new(name: 'test', cloudroot: fixture, target: fixture + 'target' )
			end
			let(:formatter) { DefaultScanFormatter.new }
			context 'with no new dir' do
				it 'returns an array with the correct string' do
					sr = ScanResult.new(folder)
					expect(formatter.new_dirs(sr)).to eql ["\nThere are no new dirs to create"]
				end
			end
			context 'with one new dir' do
				it 'returns the single new dir string and the new dir name' do
					sr = ScanResult.new(folder)
					sr.add_new_dir('/mnt/target/new_dir')
					expect(formatter.new_dirs(sr)).to eql ["\nThere is one new dir", "/mnt/target/new_dir"]
				end
			end
			context 'with 3 new dirs' do
				it 'returns the correct number in the string with the new dirs' do
					sr = ScanResult.new(folder)
					sr.add_new_dir('/mnt/target/new_dir1')
					sr.add_new_dir('/mnt/target/new_dir2')
					sr.add_new_dir('/mnt/target/new_dir3')
					expected = ["\nThere are 3 new dirs", "/mnt/target/new_dir1",
									"/mnt/target/new_dir2", "/mnt/target/new_dir3"]
					expect(formatter.new_dirs(sr)).to eql expected
				end
			end
		end

		describe '#duplicates' do
			let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
			let(:folder) do
				Folder.new(name: 'test', cloudroot: fixture, target: fixture + 'target' )
			end
			let(:formatter) { DefaultScanFormatter.new }
			context 'with no new dir' do
				it 'returns an array with the correct string' do
					sr = ScanResult.new(folder)
					expect(formatter.duplicates(sr)).to eql ["\nThere are no duplicated file names"]
				end
			end
			context 'with one new dir' do
				it 'returns the single new dir string and the new dir name' do
					sr = ScanResult.new(folder)
					sr.add_duplicate('/mnt/target/duplicate')
					expect(formatter.duplicates(sr)).to eql ["\nThere is one filename which already exists in the target dir", "/mnt/target/duplicate"]
				end
			end
			context 'with 3 new dirs' do
				it 'returns the correct number in the string with the new dirs' do
					sr = ScanResult.new(folder)
					sr.add_duplicate('/mnt/target/duplicate1')
					sr.add_duplicate('/mnt/target/duplicate2')
					sr.add_duplicate('/mnt/target/duplicate3')
					expected = ["\nThere are 3 filenames which already exist in the target dir", "/mnt/target/duplicate1",
									"/mnt/target/duplicate2", "/mnt/target/duplicate3"]
					expect(formatter.duplicates(sr)).to eql expected
				end
			end
		end

	end

end
