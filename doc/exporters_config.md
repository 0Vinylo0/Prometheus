# Configuración de Exporters

Los exporters son herramientas que recopilan métricas específicas de sistemas, hardware o aplicaciones y las exponen en un formato que Prometheus puede recopilar. Aquí configuraremos el **Node Exporter** y otros exporters comunes.

---

## Nota sobre los Exporters en Repositorios
Algunos exporters, como el **Node Exporter**, están disponibles en los repositorios oficiales de ciertas distribuciones de Linux. Sin embargo, no todos los exporters están empaquetados oficialmente. Se recomienda verificar primero si el exporter deseado está disponible en los repositorios con:
```bash
sudo apt search <nombre-del-exporter>
```
Si el exporter no está disponible, puedes seguir los pasos de instalación manual descritos a continuación.

---

## Node Exporter
El Node Exporter recopila métricas básicas del sistema operativo, como CPU, memoria y uso de disco.

### Instalación desde Repositorios (si está disponible)
1. Busca el paquete:
   ```bash
   sudo apt search prometheus-node-exporter
   ```
2. Si está disponible, instala el Node Exporter:
   ```bash
   sudo apt install prometheus-node-exporter
   ```
3. Verifica el estado del servicio:
   ```bash
   sudo systemctl status prometheus-node-exporter
   ```

### Instalación Manual

#### 1. Descargar Node Exporter
1. Ve al [sitio oficial de descargas de Prometheus](https://prometheus.io/download/).
2. Copia el enlace de la última versión estable del Node Exporter para Linux.
3. Descarga el archivo tarball:
   ```bash
   wget https://github.com/prometheus/node_exporter/releases/download/<version>/node_exporter-<version>.linux-amd64.tar.gz
   ```

#### 2. Extraer y Configurar
1. Extrae los archivos descargados:
   ```bash
   tar -xvzf node_exporter-<version>.linux-amd64.tar.gz
   ```
2. Mueve el binario al directorio adecuado:
   ```bash
   sudo mv node_exporter-<version>.linux-amd64/node_exporter /usr/local/bin/
   ```

#### 3. Crear un Servicio para Node Exporter
1. Crea un usuario dedicado:
   ```bash
   sudo useradd --no-create-home --shell /bin/false node_exporter
   ```
2. Configura el servicio:
   ```bash
   sudo nano /etc/systemd/system/node_exporter.service
   ```
3. Añade el siguiente contenido:
   ```ini
   [Unit]
   Description=Node Exporter
   Wants=network-online.target
   After=network-online.target

   [Service]
   User=node_exporter
   Group=node_exporter
   Type=simple
   ExecStart=/usr/local/bin/node_exporter

   [Install]
   WantedBy=multi-user.target
   ```
4. Inicia y habilita el servicio:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start node_exporter
   sudo systemctl enable node_exporter
   ```

### 4. Verificar la Instalación
1. Accede a `http://<tu-ip>:9100/metrics` para comprobar que Node Exporter está exponiendo las métricas.
2. Configura Prometheus para recopilar estas métricas añadiendo el siguiente bloque al archivo `prometheus.yml`:
   ```yaml
   scrape_configs:
     - job_name: 'node_exporter'
       static_configs:
         - targets: ['localhost:9100']
   ```
3. Reinicia Prometheus:
   ```bash
   sudo systemctl restart prometheus
   ```

---

## Exporters Adicionales

### Blackbox Exporter
El Blackbox Exporter permite monitorear endpoints HTTP, HTTPS, DNS, TCP, y más.

1. Descarga y configura:
   ```bash
   wget https://github.com/prometheus/blackbox_exporter/releases/download/<version>/blackbox_exporter-<version>.linux-amd64.tar.gz
   tar -xvzf blackbox_exporter-<version>.linux-amd64.tar.gz
   sudo mv blackbox_exporter-<version>.linux-amd64/blackbox_exporter /usr/local/bin/
   ```
2. Configura un servicio similar al Node Exporter.
3. Accede a `http://<tu-ip>:9115/metrics` para verificar su funcionamiento.

### PostgreSQL Exporter
Este exporter recopila métricas de bases de datos PostgreSQL.

1. Instala el exporter (verifica primero si está en los repositorios):
   ```bash
   sudo apt search prometheus-postgres-exporter
   ```
2. Si no está disponible, descarga manualmente:
   ```bash
   wget https://github.com/prometheus-community/postgres_exporter/releases/download/<version>/postgres_exporter-<version>.linux-amd64.tar.gz
   tar -xvzf postgres_exporter-<version>.linux-amd64.tar.gz
   sudo mv postgres_exporter-<version>.linux-amd64/postgres_exporter /usr/local/bin/
   ```
3. Configura las credenciales de PostgreSQL en una variable de entorno:
   ```bash
   export DATA_SOURCE_NAME="postgresql://usuario:contraseña@localhost:5432/postgres?sslmode=disable"
   ```
4. Inicia el exporter:
   ```bash
   postgres_exporter
   ```

### Apache Exporter
El Apache Exporter recopila métricas del servidor web Apache, como tráfico, solicitudes activas y estado de los workers.

1. Verifica si el exporter está disponible en los repositorios:
   ```bash
   sudo apt search prometheus-apache-exporter
   ```
2. Si no está disponible, instala manualmente:
   ```bash
   wget https://github.com/Lusitaniae/apache_exporter/releases/download/<version>/apache_exporter-<version>.linux-amd64.tar.gz
   tar -xvzf apache_exporter-<version>.linux-amd64.tar.gz
   sudo mv apache_exporter-<version>.linux-amd64/apache_exporter /usr/local/bin/
   ```
3. Configura el módulo de estado en Apache:
   - Edita el archivo de configuración de Apache:
     ```bash
     sudo nano /etc/apache2/mods-enabled/status.conf
     ```
   - Asegúrate de que la configuración permita el acceso desde localhost:
     ```apache
     <Location /server-status>
         SetHandler server-status
         Require local
     </Location>
     ```
   - Habilita el módulo de estado si no lo está:
     ```bash
     sudo a2enmod status
     sudo systemctl restart apache2
     ```
4. Configura Prometheus para recopilar las métricas:
   ```yaml
   scrape_configs:
     - job_name: 'prometheus_apache_exporter'
       static_configs:
         - targets: ['localhost:9117']
   ```
6. Reinicia Prometheus:
   ```bash
   sudo systemctl restart prometheus
   ```
---

## Conclusión
Ahora tienes configurados el Node Exporter y otros exporters básicos. Esto te permitirá monitorear el sistema operativo y aplicaciones específicas. Asegúrate de actualizar el archivo `prometheus.yml` para incluir estos nuevos endpoints de métricas.
