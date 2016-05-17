# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}

# A lookup table for EPEL GPG keys & RPM URLs for various RedHat releases
{% if grains['osmajorrelease'][0] == '5' %}
  {% set pkg = {
    'key': 'https://getfedora.org/static/A4D647E9.txt',
    'key_hash': 'sha256=664c06f579d914f2cf25d05d4d581b8ddec77cae4f72f4020c3a9264b9d5ee71',
    'key_name': 'RPM-GPG-KEY-EPEL-5',
    'rpm': 'http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '6' %}
  {% set pkg = {
    'key': 'https://getfedora.org/static/0608B895.txt',
    'key_hash': 'sha256=16d35fa467c6efcee21d3aa068a02054b6a89a7a33bffa94db1fc141693d62a3',
    'key_name': 'RPM-GPG-KEY-EPEL-6',
    'rpm': 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '7' %}
  {% set pkg = {
    'key': 'https://getfedora.org/static/352C64E5.txt',
    'key_hash': 'sha256=22f25ad95d5e8d371760815485dba696ea3002fc2c7f812f2c75276853387107',
    'key_name': 'RPM-GPG-KEY-EPEL-7',
    'rpm': 'http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm',
  } %}
{% elif grains['os'] == 'Amazon' and grains['osmajorrelease'] in ['2014', '2015', '2016' ]  %}
  {% set pkg = {
    'key': 'https://fedoraproject.org/static/0608B895.txt',
    'key_hash': 'sha256=16d35fa467c6efcee21d3aa068a02054b6a89a7a33bffa94db1fc141693d62a3',
    'key_name': 'RPM-GPG-KEY-EPEL-6',
    'rpm': 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm',
  } %}
{% endif %}


install_pubkey_epel:
  file.managed:
    - name: /etc/pki/rpm-gpg/{{ salt['pillar.get']('epel:pubkey_name', pkg.key_name) }}
    - source: {{ salt['pillar.get']('epel:pubkey', pkg.key) }}
    - source_hash:  {{ salt['pillar.get']('epel:pubkey_hash', pkg.key_hash) }}


epel_release:
  pkg.installed:
    - sources:
      - epel-release: {{ salt['pillar.get']('epel:rpm', pkg.rpm) }}
    - require:
      - file: install_pubkey_epel

set_pubkey_epel:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/epel.repo
    - pattern: '^gpgkey=.*'
    - repl: 'gpgkey=file:///etc/pki/rpm-gpg/{{ salt['pillar.get']('epel:pubkey_name', pkg.key_name) }}'
    - require:
      - pkg: epel_release

set_gpg_epel:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/epel.repo
    - pattern: 'gpgcheck=.*'
    - repl: 'gpgcheck=1'
    - require:
      - pkg: epel_release

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
