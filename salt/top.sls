base:
  '*':
    - curl
    - monitor_grain
    - diamond

  '*-monitor':
    - monitor_master_grain
    - graphite
