{% set target_kernel_version = "5.6.87.2-microsoft-standard-WSL2" %}
{% set current_kernel = grains['kernelrelease'] %}

check_kernel:
  test.succeed_without_changes:
    - name: "Current kernel on {{ grains['id'] }}: {{ current_kernel }} (Target: {{ target_kernel_version }})"

{% if current_kernel.strip() == target_kernel_version.strip() %}

create_info_file:
  file.managed:
    - name: /tmp/kernel_info.txt
    - contents: |
        User: {{ salt['pillar.get']('kernel_check:name', 'Unknown User') }}
        Department: {{ salt['pillar.get']('kernel_check:department', 'Unknown Department') }}
        Notes: {{ salt['pillar.get']('kernel_check:notes', 'No notes provided') }}
        Kernel Version: {{ current_kernel }}
    - mode: '0644'
    - user: root
    - group: root

{% else %}

no_action_needed:
  test.succeed_without_changes:
    - name: "Kernel version does not match. Skipping file creation."

{% endif %}
