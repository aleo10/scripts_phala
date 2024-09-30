#!/bin/bash

# Actualizar repositorios e instalar htop y cgroup-tools
echo "Actualizando repositorios e instalando htop y cgroup-tools..."
sudo apt update
sudo apt install -y htop cgroup-tools

# Limitar los subprocesos de ./app al núcleo 0 usando taskset
echo "Limitar subprocesos de ./app al núcleo 0 con taskset..."
ps -eLf | grep "[.]\/app" | awk '{print $4}' | xargs -I {} sudo taskset -p 0x1 {}

# Crear el cgroup y configurar la limitación de CPU al 50%
echo "Creando el cgroup y limitando el uso de CPU al 50%..."
sudo cgcreate -g cpu:/limited_group
echo 50000 | sudo tee /sys/fs/cgroup/cpu/limited_group/cpu.cfs_quota_us
echo 100000 | sudo tee /sys/fs/cgroup/cpu/limited_group/cpu.cfs_period_us

# Añadir los subprocesos de ./app al cgroup
echo "Añadiendo subprocesos de ./app al cgroup..."
for pid in $(ps -eLf | grep "[.]\/app" | awk '{print $4}'); do
    sudo cgclassify -g cpu:/limited_group $pid
done

echo "Subprocesos de ./app limitados al núcleo 0 y añadidos al cgroup 'limited_group'."
