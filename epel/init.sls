{% from "epel/map.jinja" import epel with context %}

# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}

install_pubkey_epel:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    - source: {{ epel.key }}
    - source_hash:  {{ epel.key_hash }}

epel_release:
  pkg.installed:
    - sources:
      - epel-release: {{ epel.rpm }}
    - requires:
      - file: install_pubkey_epel

set_pubkey_epel:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^gpgkey=.*'
    - repl: 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL'
    - requires:
      - pkg: epel-release

set_gpg_epel:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/epel.repo
    - pattern: 'gpgcheck=.*'
    - repl: 'gpgcheck=1'
    - requires:
      - pkg: epel-release

{% if salt['pillar.get']('epel:disabled', False) %}
disable_epel:
  file.replace:
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^enabled=[0,1]'
    - repl: 'enabled=0'
{% else %}
enable_epel:
  file.replace:
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^enabled=[0,1]'
    - repl: 'enabled=1'
{% endif %}
{% endif %}
