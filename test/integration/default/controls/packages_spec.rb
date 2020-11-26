# frozen_string_literal: true

control 'epel package' do
  title 'should be installed'

  pkg = 'epel-release'
  version =
    case platform[:name]
    when 'amazon'
      case platform[:release]
      when '2'
        '7-12'
      when '2018.03'
        '6-8'
      end
    when 'centos'
      if platform[:release].start_with?('8')
        '8-8.el8'
      elsif platform[:release].start_with?('7')
        '7-13'
      elsif platform[:release].start_with?('6')
        '6-8'
      end
    end

  describe package(pkg) do
    it { should be_installed }
    its('version') { should eq version }
  end
end
