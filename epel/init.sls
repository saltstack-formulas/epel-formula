install_pubkey:
  file:
    - managed
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    - source: {{ salt['pillar.get']('epel:pubkey') }}
    - source_hash:  {{ salt['pillar.get']('epel:pubkey_hash') }}

install_rpm:
  pkg:
    - installed
    - sources:
      - rpm: {{ salt['pillar.get']('epel:rpm') }}
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
