#!/usr/bin/python
#coding: utf-8 -*-

DOCUMENTATION = """
---
author: Michael Sambol
module: ceph_pool
short_description: Creates ceph pool and ensures correct pg count
description:
  There are three possible outcomes:
    1/ Create a new pool if it doesn't exist
    2/ Set the pool's pg count to correct number
    3/ Nothing: pool is created and pg count is correct
options:
  pool_name:
    description:
      - The pool in question: create it or ensure correct pg count
    required: true
  osds:
    description:
      - The osds count: pg count is calculated based on this
    required: true
"""

EXAMPLES = """
# ceph_pool can only be run on nodes that have an admin keyring
# pool_name = default
- ceph_pool:
    pool_name: default
    osds: "{{ groups['ceph_osds_ssd']|length * ceph.disks|length }}"
  register: pool_output
  run_once: true
  delegate_to: "{{ groups['ceph_monitors'][0] }}"
"""

import time

def main():
    module = AnsibleModule(
        argument_spec=dict(
            pool_name=dict(required=True),
            osds=dict(required=True, type='int'),
        ),
    )

    pool_name = module.params.get('pool_name')
    osds = module.params.get('osds')

    # calculate desired pg count
    # 100 is a constant and 3 is the number of copies
    # read more about pg count here: http://ceph.com/pgcalc/
    total_pg_count = (osds * 100) / 3
    i = 0
    desired_pg_count = 0
    while desired_pg_count < total_pg_count:
        desired_pg_count = 2**i
        i += 1

    # if desired_pg_count is > 32 pgs/osd, ceph throws a warning
    # common protocol is to divide by 2
    while desired_pg_count / osds > 32:
        desired_pg_count = desired_pg_count / 2

    # does the pool exist already?
    cmd = ['ceph', 'osd', 'pool', 'get', pool_name, 'pg_num']
    rc, out, err = module.run_command(cmd, check_rc=False)

    # no
    if rc != 0:
        # create the pool
        cmd = ['ceph', 'osd', 'pool', 'create', pool_name,
               str(desired_pg_count), str(desired_pg_count)]
        rc, out, err = module.run_command(cmd, check_rc=True)
        module.exit_json(changed=True, msg="new pool was created")
    # yes
    else:
        module.exit_json(changed=False)

from ansible.module_utils.basic import *
main()
