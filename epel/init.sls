# A lookup table for EPEL GPG keys & RPM URLs for various RedHat releases
{% set _rh_rel = {
  'CentOS-5': {
    'key': 'https://fedoraproject.org/static/A4D647E9.txt',
    'key_hash': 'md5=a1d12cd9628338ddb12e9561f9ac1d6a',
    'rpm': 'http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm',
  },
  'CentOS-6': {
    'key': 'https://fedoraproject.org/static/0608B895.txt',
    'key_hash': 'md5=eb8749ea67992fd622176442c986b788',
    'rpm': 'http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm',
  },
} %}

# Pulls key from the above structure for the current OS
{% macro lookup(thing) -%}
{{ _rh_rel[grains['osfinger']][thing] }}
{%- endmacro %}

# Completely ignore non-CentOS, non-RHEL systems
{% if grains['osfullname'] in ('CentOS', 'RHEL') %}
install_pubkey:
  file:
    - managed
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    - source: {{ salt['pillar.get']('epel:pubkey', lookup('key')) }}
    - source_hash:  {{ salt['pillar.get']('epel:pubkey_hash', lookup('key_hash') }}

install_rpm:
  pkg:
    - installed
    - sources:
      - rpm: {{ salt['pillar.get']('epel:rpm', lookup('rpm')) }}
    - requires:
      - file: install_pubkey

{% if salt['pillar.get']('epel:disabled', False) %}
disable_epel:
  file:
    - sed
    - name: /etc/yum.repos.d/epel.repo
    - limit: '^enabled'
    - before: 1
    - after: 0
{% endif %}
{% endif %}
