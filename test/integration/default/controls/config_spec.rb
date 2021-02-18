# frozen_string_literal: true

control 'epel repo configuration' do
  title 'should match desired lines'

  epel_version =
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

  describe file("/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-#{epel_version}") do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end
end
