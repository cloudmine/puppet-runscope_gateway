require 'spec_helper'

describe 'runscope_gateway' do
  RSpec.configure do |c|
    c.default_facts = {
      :architecture           => 'amd64',
      :kernel                 => 'Linux',
      :operatingsystem        => 'Ubuntu',
      :operatingsystemrelease => '14.04',
      :osfamily               => 'Debian',
      :puppetversion          => '4.3.2',
    }
  end

  context 'When defaults' do
    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Please provide Runscope application token/) }
  end

  context 'When defaults and token parameter provided on any OS' do
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}
    it { should contain_class('archive') }
    it { should contain_class('runscope_gateway') }
    it { should contain_class('runscope_gateway::install') }
    it { should contain_class('runscope_gateway::config') }
    it { should contain_class('runscope_gateway::service') }

    it { should contain_group('runscope') }
    it { should contain_user('runscope') }
  end

  context 'When defaults and token parameter provided on CentOS 6.0' do
    let(:facts) {{
      :kernel                 => 'Linux',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.0',
      :osfamily               => 'RedHat',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}

    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Unimplemented service configuration/) }
  end

  context 'When defaults and token parameter provided on CentOS 7.0' do
    let(:facts) {{
      :kernel                 => 'Linux',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '7.0',
      :osfamily               => 'RedHat',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}

    it { should contain_file('/lib/systemd/system/runscope-gateway.service').with({
      'ensure'  => 'file',
    }).with_content(/^ExecStart=\/opt\/runscope\/runscope-gateway -f \/etc\/runscope\/gateway\.conf/) }
  end

  context 'When defaults and token parameter provided on Darwin' do
    let(:facts) {{
      :kernel                 => 'Darwin',
      :operatingsystem        => 'Darwin',
      :operatingsystemrelease => '15.3.0',
      :osfamily               => 'Darwin',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}
    
    it { should contain_file('/usr/local/opt/runscope').with({
      'ensure' => 'directory'
    }) }

    it { should contain_file('/Library/LaunchDaemons/com.runscope.gateway.plist').with({
      'ensure'  => 'file',
    }).with_content(/\<string\>\/usr\/local\/opt\/runscope\/runscope-gateway\<\/string\>/) }

    it { should contain_file('/usr/local/etc/runscope').with({
      'ensure' => 'directory'
    }) }
    it { should contain_file('/usr/local/etc/runscope/gateway.conf').with({
      'ensure' => 'file',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    }).with_content(/^hostname=\w+/) }

    it { should contain_service('runscope-gateway').with({
      'ensure' => 'running',
      'enable' => 'true',
    }) }
  end

  context 'When defaults and token parameter provided on Debian 7' do
    let(:facts) {{
      :kernel                 => 'Linux',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '7.0',
      :osfamily               => 'Debian',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}

    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Unimplemented service configuration/) }
  end

  context 'When defaults and token parameter provided on Debian 8' do
    let(:facts) {{
      :kernel                 => 'Linux',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '8.0',
      :osfamily               => 'Debian',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}

    it { should contain_file('/lib/systemd/system/runscope-gateway.service').with({
      'ensure'  => 'file',
    }).with_content(/^ExecStart=\/opt\/runscope\/runscope-gateway -f \/etc\/runscope\/gateway\.conf/) }
end

  context 'When defaults and token parameter provided on Linux' do
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}
    
    it { should contain_file('/opt/runscope').with({
      'ensure' => 'directory'
    }) }

    it { should contain_file('/etc/runscope').with({
      'ensure' => 'directory'
    }) }
    it { should contain_file('/etc/runscope/gateway.conf').with({
      'ensure' => 'file',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    }).with_content(/^hostname=\w+/) }

    it { should contain_service('runscope-gateway').with({
      'ensure' => 'running',
      'enable' => 'true',
    }) }
  end

  context 'When defaults and token parameter provided on Ubuntu 14.04' do
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}

    it { should contain_file('/etc/init/runscope-gateway.conf').with({
      'ensure'  => 'file',
    }).with_content(/^exec \/opt\/runscope\/runscope-gateway -f \/etc\/runscope\/gateway\.conf/) }
  end

  context 'When defaults and token parameter provided on Ubuntu 16.04' do
    let(:facts) {{
      :operatingsystemrelease => '16.04',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}

    it { should contain_file('/lib/systemd/system/runscope-gateway.service').with({
      'ensure'  => 'file',
    }).with_content(/^ExecStart=\/opt\/runscope\/runscope-gateway -f \/etc\/runscope\/gateway\.conf/) }
  end

  context 'When defaults and token parameter provided on Windows' do
    let(:facts) {{
      :kernel                 => 'Windows',
      :operatingsystem        => 'Windows',
      :operatingsystemrelease => 'Server 2012',
      :osfamily               => 'Windows',
    }}
    let(:params) {{
      :token => 'abcd-efgh-ijklmnop',
    }}
    
    it { should contain_file('c:/Program Files/Runscope').with({
      'ensure' => 'directory'
    }) }

    it { should contain_file('c:/Program Files/Runscope/gateway.conf').with({
      'ensure' => 'file',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0644',
    }).with_content(/^hostname=\w+/) }

    it { should contain_service('runscope-gateway').with({
      'ensure' => 'running',
      'enable' => 'true',
    }) }
  end

  context 'When https and no certfile' do
    let(:params) {{
      :https    => true,
      :keyfile => '/etc/ssl/private/ssl-cert-snakeoil.key',
      :token    => 'abcd-efgh-ijklmnop',
    }}
    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Please provide certfile when enabling HTTPS/) }
  end

  context 'When https and no keyfile' do
    let(:params) {{
      :certfile => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
      :https    => true,
      :token    => 'abcd-efgh-ijklmnop',
    }}
    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Please provide keyfile when enabling HTTPS/) }
  end

  context 'When https and both certfile and keyfile' do
    let(:params) {{
      :certfile => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
      :https    => true,
      :keyfile  => '/etc/ssl/private/ssl-cert-snakeoil.key',
      :token    => 'abcd-efgh-ijklmnop',
    }}
    it { should contain_file('/etc/runscope/gateway.conf').with_content(/^https$/).with_content(/^certfile=\/etc\/ssl\/certs\/ssl-cert-snakeoil.pem$/).with_content(/^keyfile=\/etc\/ssl\/private\/ssl-cert-snakeoil.key$/) }
  end

  context 'When interface' do
    let(:params) {{
      :interface => '10.0.0.2',
      :token     => 'abcd-efgh-ijklmnop',
    }}
    it { should contain_file('/etc/runscope/gateway.conf').with_content(/^interface=10\.0\.0\.2$/) }
  end

  context 'When unsupported architecture' do
    let(:facts) {{ :architecture => 'bogus' }}
    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Unimplemented kernel architecture/) }
  end

  context 'When not managing group' do
    let(:params) {{
      :group_manage => false,
      :token        => 'abcd-efgh-ijklmnop',
    }}
    it { should_not contain_group('runscope') }
  end

  context 'When not managing service' do
    let(:params) {{
      :service_manage => false,
      :token          => 'abcd-efgh-ijklmnop',
    }}
    it { should_not contain_file('/etc/init/runscope-gateway.conf') }
    it { should_not contain_service('runscope-gateway') }
  end

  context 'When not managing user' do
    let(:params) {{
      :token       => 'abcd-efgh-ijklmnop',
      :user_manage => false,
    }}
    it { should_not contain_user('runscope') }
  end

  context 'When service disabled' do
    let(:params) {{
      :service_enable => false,
      :token          => 'abcd-efgh-ijklmnop',
    }}
    it { should contain_service('runscope-gateway').with({
      'enable' => 'false',
    }) }
  end

  context 'When service stopped' do
    let(:params) {{
      :service_ensure => 'stopped',
      :token          => 'abcd-efgh-ijklmnop',
    }}
    it { should contain_service('runscope-gateway').with({
      'ensure' => 'stopped',
    }) }
  end

  context 'When unsupported service style' do
    let(:params) {{
      :service_style => 'foobar',
      :token         => 'abcd-efgh-ijklmnop',
    }}
    it { should_not compile() }
    it { should raise_error(Puppet::Error, /runscope_gateway: Unimplemented service configuration/) }
  end
end
