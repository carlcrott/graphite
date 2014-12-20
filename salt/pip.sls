python-pip:
  pkg.installed

requests:
  pip.installed:
    - name: requests >= 0.12.0
    - require:
      - pkg: python-pip

/root/executable:
  file.recurse:
    - source: salt://executable
    - include_empty: True
    - dir_mode: 2775
    - file_mode: '0755'

/root/script:
  file.recurse:
    - source: salt://script
    - include_empty: True
    - dir_mode: 2775
    - file_mode: '0755'

/root/scratch:
  file.directory:
    - user: root
    - group: root