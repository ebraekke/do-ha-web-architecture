#cloud-config
package_upgrade: false
users:
  - name: jump    
    shell: /bin/false
    ssh-authorized-keys:
      - ${jump_key}
runcmd:
  - [touch, /tmp/cloud-init-begin]
  - [sed, -i,'s/PermitRootLogin.*/PermitRootLogin no/g',/etc/ssh/sshd_config]
  - [systemctl, restart, ssh]
  - [touch, /tmp/cloud-init-done]