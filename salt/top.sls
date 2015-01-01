base:
  '*':
    - curl
    - monitor_grain
    - graphite.diamond

  '*-monitor':
    - monitor_master_grain
    - graphite
