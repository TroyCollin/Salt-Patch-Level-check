{% set target_kernel_version = "5.15.0-100-generic" %}
{% set current_kernel = salt['cmd.run']('uname -r') %}

check_kernel:
  test.show_notification:
    - text: "Current kernel on {{ grains['id'] }}: {{ current_kernel }}"

{% if current_kernel == target_kernel_version %}
  # Collect user input
  {% set name = salt['pillar.get']('kernel_check:name', 'Unknown User') %}
  {% set department = salt['pillar.get']('kernel_check:department', 'Unknown Department') %}
  {% set notes = salt['pillar.get']('kernel_check:notes', 'No notes provided') %}

  # Define file content
  create_info_file:
    file.managed:
      - name: /tmp/kernel_info.txt
      - contents: |
          User: {{ name }}
          Department: {{ department }}
          Notes: {{ notes }}
          Kernel Version: {{ current_kernel }}
      - mode: '0644'
      - user: root
      - group: root
{% else %}
  no_action_needed:
    test.show_notification:
      - text: "Kernel version does not match. Skipping file creation."
{% endif %}
