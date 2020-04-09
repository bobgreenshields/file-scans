require_relative '../lib/fs_parser'

include FileScans

describe FSParser do
	let(:fsp) { FSParser.new }
	describe '#call' do
		context 'when ARGV contains -d' do
			it 'returns a set containing :dirs' do
				args = %w(-d)
				expect(fsp.call(args)).to eql Set[:dirs]
			end
		end
		context 'when ARGV contains --dirs' do
			it 'returns a set containing :dirs' do
				args = %w(--dirs)
				expect(fsp.call(args)).to eql Set[:dirs]
			end
		end

		context 'when ARGV contains -f' do
			it 'returns a set containing :files' do
				args = %w(-f)
				expect(fsp.call(args)).to eql Set[:files]
			end
		end
		context 'when ARGV contains --files' do
			it 'returns a set containing :files' do
				args = %w(--files)
				expect(fsp.call(args)).to eql Set[:files]
			end
		end

		context 'when ARGV contains -fd' do
			it 'returns a set containing :files and :dirs' do
				args = %w(-fd)
				expect(fsp.call(args)).to eql Set[:files, :dirs]
			end
		end

		context 'when ARGV contains -m' do
			it 'returns a set containing :scan and :move' do
				args = %w(-m)
				expect(fsp.call(args)).to eql Set[:scan, :move]
			end
		end

	end
	
end
