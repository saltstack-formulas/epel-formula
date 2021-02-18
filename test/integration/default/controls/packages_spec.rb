# frozen_string_literal: true

control 'epel package' do
  title 'should be installed'

  pkg = 'epel-release'
  version =
    case platform[:name]
    when 'amazon'
      case platform[:release]
      when '2'
        '7'
      when '2018.03'
        '6'
      end
    else
      platform[:release][0]
    end

  describe package(pkg) do
    it { should be_installed }
    its('version') { should match(/^#{version}/) }
  end
end
