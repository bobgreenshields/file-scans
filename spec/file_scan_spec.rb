require_relative '../lib/file_scan'
# require_relative '../lib/folder'

include FileScans

describe FileScan do
	describe '#load_folder' do
		it 'loads a folder' do
			folders = [ {'name' => 'inv', 'target' => '/mnt/inv'},
				{'name' => 'fin', 'target' => '/mnt/fin'} ]
			fs = FileScan.new
			fs.load_folder(folders[0])
			
		end
	end
	describe '#load_folders' do
		it 'sets the cloudroot' do
			config = {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ]
			}
			fs = FileScan.new
			allow(fs).to receive(:config_hash).and_return(config)
			# allow(fs).to receive(:exit_cloudroot_not_exist)
			# allow(fs).to receive(:load_folders)
			# expect(fs.config_hash).to be_a Hash
			# expect(fs.config_hash['folders']).to be_a Array
			# expect(fs.config_hash['cloudroot']).to eql '/home/bobg/ncfiling'
			# expect(fs.cloudroot).to be_a Pathname
			fs.load_folders
			expect(fs.cloudroot.to_s).to eql('/home/bobg/ncfiling')
			
			
		end
		
	end
	
end
