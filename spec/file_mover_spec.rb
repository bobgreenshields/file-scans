require_relative '../lib/file_mover'
require_relative '../lib/folder'
require_relative '../lib/scan_result'

include FileScans

describe FileMover do
	before :each do
		@fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
		@target = @fixture + 'target'
		@new_dir_name = 'inv/dgs/new'
		@new_dir = @target + @new_dir_name
		@new_dir.rmtree if @new_dir.exist?
		expect(@new_dir.exist?).to be_falsey
		@new_file_names = %w(inv/dgs/new/file1.txt filing/car/file2.txt)
		@new_file_names.each do | file_name |
			new_file = @target + file_name
			new_file.delete if new_file.exist?
			expect(new_file.exist?).to be_falsey
			source = @fixture + 'builder' + file_name
			source.write("") unless source.exist?
			expect(source.exist?).to be_truthy
		end
		@folder = Folder.new(name: 'builder', cloudroot: @fixture,
												target: @target )
		@sr = ScanResult.new(@folder)
		@sr.add_new_dir(@new_dir_name)
		@new_file_names.inject(@sr) { |sr, file| sr.add_file(file) }
		@fm = FileMover.new(@sr)
	end

	it 'makes the new dirs' do
			@fm.call
			expect(@new_dir.exist?).to be_truthy
	end
	it 'moves the files' do
		@fm.call
		@new_file_names.each do | file_name |
			source = @fixture + 'builder' + file_name
			target = @target + file_name
			expect(source.exist?).to be_falsey
			expect(target.exist?).to be_truthy
		end
	end
	it 'calls on_new_dir_create' do
		calls = 0
		@fm.on_new_dir_create = ->(dir, target_dir) { calls += 1 }
		@fm.call
		expect(calls).to eql 1
	end
	it 'calls on_file_move' do
		calls = 0
		@fm.on_file_move = ->(dir, target_dir) { calls += 1 }
		@fm.call
		expect(calls).to eql 2
	end
	
end
