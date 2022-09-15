require 'spec_helper_acceptance'

describe 'vim class:' do
  context 'with default values for class parameters' do
    it 'runs successfully' do
      pp = <<-EOS
      include vim
      EOS

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
