require_relative '../lib/file_mover'
require_relative '../lib/folder'
require_relative '../lib/scan_result'

include FileScans

describe FileMover do
	it 'makes the new dirs' do
			fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
			target = fixture + 'target'
			new_dir_name = 'inv/dgs/new'
			new_dir = target + new_dir_name
			new_dir.rmtree if new_dir.exist?
			expect(new_dir.exist?).to be_falsey
			folder = Folder.new(name: 'builder', cloudroot: fixture,
													target: target )
			sr = ScanResult.new(folder)
			sr.add_new_dir(new_dir_name)
			fm = FileMover.new(sr)
			fm.call
			expect(new_dir.exist?).to be_truthy


		
	end
	
end
