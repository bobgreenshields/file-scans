require_relative '../lib/file_scan'
# require_relative '../lib/folder'

include FileScans

describe FileScan do
	describe '#load_folder' do
		it 'loads a folder' do
			folders = [ {'name' => 'inv', 'target' => '/mnt/inv'},
				{'name' => 'fin', 'target' => '/mnt/fin'} ]
			fs = FileScan.new
			allow(fs).to receive(:exit_folder_target_not_exist)
			fs.load_folder(folder_hash: folders[0], cloudroot: '/dev/builder')
			fs.load_folder(folder_hash: folders[1], cloudroot: '/dev/builder')
			expect(fs.folders.map(&:name)).to eql(['inv', 'fin'])
			
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
			allow(fs).to receive(:exit_cloudroot_not_exist)
			allow(fs).to receive(:exit_folder_target_not_exist)
			fs.load_folders
			expect(fs.cloudroot.to_s).to eql('/home/bobg/ncfiling')
			
			
		end
		
	end
	
end
