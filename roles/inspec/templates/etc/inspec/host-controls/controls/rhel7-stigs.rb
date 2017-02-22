# encoding: utf-8
# license: Apache 2.0
#title 'host-controls'

include_controls 'inspec-stig-rhel7' do
{% for control in inspec.rhel7.skip_controls %}
    skip_control '{{ control }}'
{% endfor %}
end
