#!/bin/bash

# Crear el cgroup
sudo cgcreate -g cpu:/limited_group

# Configurar la limitación de CPU al 50%
echo 50000 | sudo tee /sys/fs/cgroup/cpu/limited_group/cpu.cfs_quota_us
echo 100000 | sudo tee /sys/fs/cgroup/cpu/limited_group/cpu.cfs_period_us

# Añadir todos los subprocesos de ./app al cgroup
for pid in $(ps -eLf | grep "[.]\/app" | awk '{print $4}'); do
    sudo cgclassify -g cpu:/limited_group $pid
done

echo "Subprocesos de ./app limitados y añadidos al cgroup 'limited_group'."
