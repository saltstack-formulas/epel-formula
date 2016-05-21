# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}

{% from "epel/map.jinja" import epel with context %}

install_pubkey_epel:
  file.managed:
    - name: /etc/pki/rpm-gpg/{{ epel.key_name }}
    - source: {{ epel.key }}
    - source_hash:  {{ epel.key_hash }}


epel_release:
  pkg.installed:
    - sources:
      - epel-release: {{ epel.rpm }}
    - require:
      - file: install_pubkey_epel

set_pubkey_epel:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^\s*gpgkey=.*'
    - repl: 'gpgkey=file:///etc/pki/rpm-gpg/{{ epel.key_name }}'
    - require:
      - pkg: epel_release

set_gpg_epel:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^\s*gpgcheck=.*'
    - repl: 'gpgcheck=1'
    - require:
      - pkg: epel_release

{% if epel.disabled %}
disable_epel:
  file.replace:
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^\s*enabled=[0,1]'
    - repl: 'enabled=0'
{% else %}
enable_epel:
  file.replace:
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^\s*enabled=[0,1]'
    - repl: 'enabled=1'
{% endif %}
{% endif %}
