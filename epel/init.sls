# Completely ignore non-RHEL based systems
{% if grains['os_family'] == 'RedHat' %}

# A lookup table for EPEL GPG keys & RPM URLs for various RedHat releases
{% if grains['osmajorrelease'][0] == '5' %}
  {% set pkg = {
    'key': 'https://fedoraproject.org/static/A4D647E9.txt',
    'key_hash': 'md5=a1d12cd9628338ddb12e9561f9ac1d6a',
    'rpm': 'http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '6' %}
  {% set pkg = {
    'key': 'https://fedoraproject.org/static/0608B895.txt',
    'key_hash': 'md5=eb8749ea67992fd622176442c986b788',
    'rpm': 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm',
  } %}
{% elif grains['osmajorrelease'][0] == '7' %}
  {% set pkg = {
    'key': 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7',
    'key_hash': 'md5=58fa8ae27c89f37b08429f04fd4a88cc',
    'rpm': 'http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm',
  } %}
{% elif grains['os'] == 'Amazon' and grains['osmajorrelease'] == '2014' %}
  {% set pkg = {
    'key': 'https://fedoraproject.org/static/0608B895.txt',
    'key_hash': 'md5=eb8749ea67992fd622176442c986b788',
    'rpm': 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm',
  } %}
{% endif %}


install_pubkey:
  file:
    - managed
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    - source: {{ salt['pillar.get']('epel:pubkey', pkg.key) }}
    - source_hash:  {{ salt['pillar.get']('epel:pubkey_hash', pkg.key_hash) }}

epel_release:
  pkg:
    - installed
    - sources:
      - epel-release: {{ salt['pillar.get']('epel:rpm', pkg.rpm) }}
    - requires:
      - file: install_pubkey

{% if salt['pillar.get']('epel:disabled', False) %}
disable_epel:
  file:
    - sed
    - name: /etc/yum.repos.d/epel.repo
    - limit: '^enabled'
    - before: [0,1]
    - after: 0
{% else %}
enable_epel:
  file:
    - sed
    - name: /etc/yum.repos.d/epel.repo
    - limit: '^enabled'
    - before: [0,1]
    - after: 1
{% endif %}
{% endif %}
