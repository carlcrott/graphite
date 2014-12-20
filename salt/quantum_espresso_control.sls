/root/qe_slurm_test.out:
  file:
    - managed
    - source: salt://minion_scripts/quantum_espresso/qe_slurm_test.out
    - mode: 0755
