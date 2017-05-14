require 'spec_helper_acceptance'

describe 'cfssl class:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'should run successfully' do
    pp = "class { 'cfssl': }"

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stderr).not_to match(/error/i)
    end
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stderr).not_to eq(/error/i)

      expect(r.exit_code).to be_zero
    end
  end

  before do
    shell "rm -fv /etc/cfssl/*"
  end

  context 'ca_manage => true:' do
    it 'runs successfully' do
      pp = "class { 'cfssl': ca_manage => true }"

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).not_to match(/error/i)
      end

      shell('test -e /etc/cfssl/ca.csr')
      shell('test -e /etc/cfssl/ca-csr.json')
      shell('test -e /etc/cfssl/ca-key.pem')
      shell('test -e /etc/cfssl/ca.pem')
      shell('test -e /etc/cfssl/chain.pem')

      shell('test -e /etc/cfssl/signing.json')

      shell('test -e /etc/cfssl/intermediate-ca.csr')
      shell('test -e /etc/cfssl/intermediate-ca-csr.json')
      shell('test -e /etc/cfssl/intermediate-ca-key.pem')
      shell('test -e /etc/cfssl/intermediate-ca.pem')
      shell('test -e /etc/cfssl/intermediate-ca-signed.csr')
      shell('test -e /etc/cfssl/intermediate-ca-signed.pem')
    end
  end

  context 'service_ensure => running:' do
    it 'runs successfully' do
      pp = "class { 'cfssl':
       ca_manage => true,
       service_manage => true,
       service_ensure => running,
      }"

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).not_to match(/error/i)
      end

    end
  end

  context 'service_ensure => stopped:' do
    it 'runs successfully' do
      pp = "class { 'cfssl':
       ca_manage => true,
       service_manage => true,
       service_ensure => stopped,
      }"

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stderr).not_to match(/error/i)
      end
    end
  end

end
