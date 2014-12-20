gfortran:
  pkg.installed:
    - version: 4:4.6.3-1ubuntu5

/root/minion_install_espresso.sh:
  file:
    - managed
    - source: salt://minion_scripts/quantum_espresso/minion_install_espresso.sh
    - mode: 0755

./minion_install_espresso.sh:
  cmd.run
  #- creates: /root/espresso-5.0.2 # only run if this doesnt exist







# /root/espresso-5.0.2/:
#   archive:
#     - extracted
#     - source: http://master.exabyte.io/api/file/localhost//exabyte/apps/_tar/espresso-5.0.2.tar.gz?download=true
#     - source_hash: md5=d8b0d7ac3ddbfe0a656ec1501a2a4688
#     - tar_options: xvf
#     - archive_format: tar
#     - name: espresso-5.0.2/
#     - cmd.run: ./configure
#     - if_missing: /root/espresso-5.0.2/

# /srv/stuff/substuf:
#   file.directory:
#     - user: fred
#     - group: users
#     - mode: 755
#     - makedirs: True

# espresso-5.0.2:
#   archive:
#     - extracted
#     - name: /root/
# #    - source: http://e31988ff25324bcc4bee-5e538a3d413df2244613eca2213dab09.r81.cf1.rackcdn.com/qe_compiled.tar.gz
# #    - source_hash: md5=5aa954690c76f5de04580d45d9bbf6d6
#     - source: http://e31988ff25324bcc4bee-5e538a3d413df2244613eca2213dab09.r81.cf1.rackcdn.com/file.tar.gz
#     - source_hash: md5=7a180076d3dc43b216874e3cca21187a
#     - tar_options: xv
#     - archive_format: tar
# #    - if_missing: /root/espresso-5.0.2/





# graylog2-server:
#   archive:
#     - extracted
#     - name: /opt/
#     - source: https://github.com/downloads/Graylog2/graylog2-server/graylog2-server-0.9.6p1.tar.gz
#     - source_hash: md5=499ae16dcae71eeb7c3a30c75ea7a1a6
#     - archive_format: tar
# #    - if_missing: /opt/graylog2-server-0.9.6p1/
#     - tar_options: xv
#     