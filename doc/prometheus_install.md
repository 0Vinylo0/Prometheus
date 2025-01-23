# Instalación de Prometheus

Prometheus es una herramienta de monitoreo y alertas basada en series temporales. A continuación, te mostramos dos métodos para instalarlo en tu sistema.

---

## Opción 1: Instalación desde Repositorios (Debian/Ubuntu)
En las versiones recientes de Debian y Ubuntu, puedes instalar Prometheus directamente desde los repositorios:

1. Actualiza la lista de paquetes:
   ```bash
   sudo apt update
   ```
2. Instala Prometheus:
   ```bash
   sudo apt install prometheus
   ```
3. Verifica la instalación:
   ```bash
   prometheus --version
   ```
4. Inicia y habilita el servicio:
   ```bash
   sudo systemctl start prometheus
   sudo systemctl enable prometheus
   ```

---

## Opción 2: Instalación Manual

### 1. Descargar Prometheus
1. Ve al [sitio oficial de descargas de Prometheus](https://prometheus.io/download/).
2. Copia el enlace de la última versión estable para Linux.
3. Descarga el archivo tarball:
   ```bash
   wget https://github.com/prometheus/prometheus/releases/download/<version>/prometheus-<version>.linux-amd64.tar.gz
   ```

### 2. Extraer y Configurar
```bash
tar -xvzf prometheus-<version>.linux-amd64.tar.gz
cd prometheus-<version>.linux-amd64
sudo mv prometheus /usr/local/bin/
sudo mv promtool /usr/local/bin/
sudo mv consoles /etc/prometheus
sudo mv console_libraries /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
```

### 3. Crear un Usuario y Configurar el Servicio
```bash
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
```

Crea un archivo de servicio para Prometheus:
```bash
sudo nano /etc/systemd/system/prometheus.service
```

Contenido del archivo:
```ini
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
```

### 4. Iniciar y Habilitar Prometheus
```bash
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
```

---

## Verificación de la Instalación
1. Abre tu navegador y accede a `http://<tu-ip>:9090`.
2. Asegúrate de que la interfaz web de Prometheus esté funcionando.

---

¡Prometheus ya está instalado y listo para usarse! Procede a configurar exporters y alertas según tus necesidades.
