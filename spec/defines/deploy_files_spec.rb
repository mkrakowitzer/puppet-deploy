require 'spec_helper'
describe 'deploy::file', :type => :define do
  describe 'when deploying tar.gz' do
     let(:title) { 'sample.tar.gz' }
     let(:params) { { :url    => 'http://webserver',
                      :target => '/usr/local/sample' } }
     it {
       should contain_exec('download_sample.tar.gz').with({
         :command => '/usr/bin/wget -q -c --no-check-certificate -O /var/tmp/deploy/sample.tar.gz http://webserver/sample.tar.gz',
         :creates => '/var/tmp/deploy/sample.tar.gz'
       })
#       should contain_file('/var/tmp/deploy/sample.tar.gz')
#      should contain_exec('untarball_/var/tmp/deploy/sample.tar.gz').with({
#       :command => '/bin/tar xzf /var/tmp/deploy/sample.tar.gz -C /usr/local/sample  --no-same-owner  ',
#       :creates => '/usr/local/sample'
#      })
    }
  end
end
