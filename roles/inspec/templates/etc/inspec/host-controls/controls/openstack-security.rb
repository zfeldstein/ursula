# encoding: utf-8
# license: Apache 2.0
#title 'host-controls'

require_controls 'inspec-openstack-security' do

{% if inventory_hostname in groups['controller'] %}
{% if inspec.controls.horizon.enabled|default('False')|bool %}
{% for control in inspec.controls.horizon.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}
{% if inspec.controls.glance.enabled|default('False')|bool %}
{% for control in inspec.controls.glance.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}
{% if inspec.controls.keystone.enabled|default('False')|bool %}
{% for control in inspec.controls.keystone.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}
{% endif %}

{% if inventory_hostname in groups['controller'] or inventory_hostname in groups['cinder_volume']|default([]) %}
{% if cinder.enabled|default('False')|bool and inspec.controls.cinder.enabled|default('False')|bool %}
{% for control in inspec.controls.cinder.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}
{% endif %}

{% if inventory_hostname in groups['controller'] or inventory_hostname in groups['compute'] %}
{% if inspec.controls.nova.enabled|default('False')|bool %}
{% for control in inspec.controls.nova.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}
{% if inspec.controls.neutron.enabled|default('False')|bool %}
{% for control in inspec.controls.neutron.required_controls %}
    control '{{ control }}'
{% endfor %}
{% endif %}
{% endif %}

end
