# -*- coding: utf-8 -*-
# vim: ft=yaml
---
epel:
  lookup:
    # Disable repo so requires the --enablerepo flag to use
    disabled: false

    # Disable (default)/enable EPEL testing
    testing: false

    # Alternative, more detailed per-repo configuration
    repos:
      epel:
        enabled: true
        exclude:
          - pkg1
          - pkg2
      epel-debuginfo:
        enabled: true
      epel-source:
        enabled: true
      epel-testing:
        enabled: true
      epel-testing-debuginfo:
        enabled: true
      epel-testing-source:
        enabled: true
