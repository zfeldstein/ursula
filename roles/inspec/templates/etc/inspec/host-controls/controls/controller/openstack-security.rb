# encoding: utf-8
# license: Apache 2.0
#title 'host-controls'

require_controls 'inspec-openstack-security' do
{% for control in inspec.openstack.horizon.required_controls %}
    control '{{ control }}'
{% endfor %}
end
