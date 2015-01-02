base:
  '*':
    - curl
    - graphite.diamond

  '*-monitor':
    - graphite
    - graphite.mysqldb
