require 'spec_helper.rb'
describe 'deploy::file', :type => :define do
  describe 'when deploying tar.gz' do
     let(:title) { 'sample.tar.gz' }
     let(:params) { { :url    => 'http://webserver',
                      :target => '/usr/local/sample' } }
     it {
       should contain_exec('download_sample.tar.gz').with({
         :command => '/usr/bin/wget -q -c -O /var/tmp/deploy/sample.tar.gz http://webserver/sample.tar.gz',
         :creates => '/var/tmp/deploy/sample.tar.gz'
       })
    }
  end
end
