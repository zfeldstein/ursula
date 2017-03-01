require 'spec_helper'

files = ['ceph.conf', 'cinder_uuid', 'fsid']
 files.each do |file|
  describe file("/etc/ceph/#{file}") do
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end
end

describe file("/etc/ceph/rbdmap") do
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end

files = Dir['/var/log/ceph/*.log']
files.each do |file|
  if File.exist?("#{file}")
    describe file("#{file}") do
# ceph.log is owned by ceph on cpm nodes
# but it owned by root on osd nodes
# so we don't check the owner of ceph.log
#      it { should be_owned_by 'ceph' }
      it { should be_grouped_into 'ceph' }
      it { should be_mode 644 }
    end
  end
end
