require 'spec_helper_acceptance'

describe 'vim class:' do
  context 'with default values for class parameters' do
    it 'puppet runs successfully' do
      pp = <<-EOS
      include vim
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('vim --help') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
