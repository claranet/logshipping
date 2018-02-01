require 'spec_helper'

describe 'logshipping' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "logshipping class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('logshipping::install').that_comes_before('logshipping::config') }
          it { is_expected.to contain_class('logshipping::config') }
          it { is_expected.to contain_class('logshipping::service').that_subscribes_to('logshipping::config') }

          it { is_expected.to contain_service('logshipping') }
          it { is_expected.to contain_package('logshipping').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'logshipping class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('logshipping') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
