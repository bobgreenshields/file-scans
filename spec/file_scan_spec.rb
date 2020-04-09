require_relative '../lib/file_scan'
# require_relative '../lib/folder'

include FileScans

describe FileScan do
	describe '#cloudroot' do
		it 'returns a Pathname' do
			config = {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ] }
			fs = FileScan.new(config)
			allow(fs).to receive(:exit_if_dir_not_exist)
			expect(fs.cloudroot).to be_a Pathname
		end
		it 'has the correct location' do
			config = {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ] }
			fs = FileScan.new(config)
			allow(fs).to receive(:exit_if_dir_not_exist)
			expect(fs.cloudroot.to_s).to eql '/home/bobg/ncfiling'
		end
		
	end
	describe '#load_folder' do
		it 'loads a folder' do
			config = {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ] }
			fs = FileScan.new(config)
			folders = config['folders']
			allow(fs).to receive(:exit_if_dir_not_exist)
			fs.load_folder(folders[0])
			fs.load_folder(folders[1])
			expect(fs.folders.map(&:name)).to eql(['inv', 'fin'])
			expect(fs.folders.map(&:target).map(&:to_s)).to eql(['/mnt/inv', '/mnt/fin'])
			
		end
	end
	describe '#load_folders' do
		it 'sets the cloudroot' do
			config = {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ] }
			fs = FileScan.new(config)
			allow(fs).to receive(:exit_if_dir_not_exist)
			fs.load_folders
			expect(fs.cloudroot.to_s).to eql('/home/bobg/ncfiling')
		end
		it 'loads the folders' do
			config = {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ] }
			fs = FileScan.new(config)
			allow(fs).to receive(:exit_if_dir_not_exist)
			fs.load_folders
			expect(fs.folders.map(&:name)).to eql(['inv', 'fin'])
			expect(fs.folders.map(&:target).map(&:to_s)).to eql(['/mnt/inv', '/mnt/fin'])
		end
		
	end
	
end
