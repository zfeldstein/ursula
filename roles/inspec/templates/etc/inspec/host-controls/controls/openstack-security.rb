# encoding: utf-8
# license: Apache 2.0
#title 'host-controls'

require_controls 'inspec-openstack-security' do

{% if inventory_hostname in groups['controller'] %}
{% for control in inspec.openstack.horizon.required_controls %}
    control '{{ control }}'
{% endfor %}
{% for control in inspec.openstack.glance.required_controls %}
    control '{{ control }}'
{% endfor %}
{% for control in inspec.openstack.keystone.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}

{% if inventory_hostname in groups['controller'] or inventory_hostname in groups['cinder_volume'] %}
{% for control in inspec.openstack.cinder.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}

{% if inventory_hostname in groups['controller'] or inventory_hostname in groups['compute'] %}
{% for control in inspec.openstack.nova.required_controls %}
    control '{{ control }}'
{% endfor %}
{% for control in inspec.openstack.neutron.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}

end
