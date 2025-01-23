# Configuración de Alertas en Prometheus

Prometheus incluye un sistema de alertas que permite supervisar condiciones específicas y notificarte cuando se cumplen. Aquí te mostramos cómo configurar alertas usando Prometheus y Alertmanager.

---

## 1. Configurar Alertmanager
Alertmanager se utiliza para gestionar las alertas enviadas por Prometheus y distribuirlas a diferentes canales (como correo electrónico, Slack, etc.).

### 1.1 Descargar Alertmanager
1. Ve al [sitio oficial de descargas de Prometheus](https://prometheus.io/download/).
2. Descarga la última versión estable de Alertmanager:
   ```bash
   wget https://github.com/prometheus/alertmanager/releases/download/<version>/alertmanager-<version>.linux-amd64.tar.gz
   ```
3. Extrae los archivos:
   ```bash
   tar -xvzf alertmanager-<version>.linux-amd64.tar.gz
   sudo mv alertmanager /usr/local/bin/
   sudo mv amtool /usr/local/bin/
   ```

### 1.2 Configurar Alertmanager
1. Crea el directorio de configuración:
   ```bash
   sudo mkdir /etc/alertmanager
   ```
2. Crea el archivo de configuración:
   ```bash
   sudo nano /etc/alertmanager/alertmanager.yml
   ```
3. Añade el siguiente contenido de ejemplo para notificaciones por correo:
   ```yaml
   global:
     smtp_smarthost: 'smtp.example.com:587'
     smtp_from: 'alertas@example.com'
     smtp_auth_username: 'usuario@example.com'
     smtp_auth_password: 'contraseña'

   route:
     receiver: 'email-alert'

   receivers:
     - name: 'email-alert'
       email_configs:
         - to: 'admin@example.com'
   ```

### 1.3 Crear un Servicio para Alertmanager
1. Crea el archivo del servicio:
   ```bash
   sudo nano /etc/systemd/system/alertmanager.service
   ```
2. Añade el siguiente contenido:
   ```ini
   [Unit]
   Description=Alertmanager
   Wants=network-online.target
   After=network-online.target

   [Service]
   User=alertmanager
   Group=alertmanager
   Type=simple
   ExecStart=/usr/local/bin/alertmanager --config.file=/etc/alertmanager/alertmanager.yml

   [Install]
   WantedBy=multi-user.target
   ```
3. Inicia y habilita el servicio:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start alertmanager
   sudo systemctl enable alertmanager
   ```

---

## 2. Integrar Alertmanager con Prometheus

1. Edita el archivo de configuración de Prometheus (`prometheus.yml`):
   ```bash
   sudo nano /etc/prometheus/prometheus.yml
   ```
2. Añade la configuración de Alertmanager:
   ```yaml
   alerting:
     alertmanagers:
       - static_configs:
           - targets: ['localhost:9093']

   rule_files:
     - "alert_rules.yml"
   ```
3. Reinicia Prometheus:
   ```bash
   sudo systemctl restart prometheus
   ```

---

## 3. Crear Reglas de Alerta

1. Crea un archivo para las reglas de alerta:
   ```bash
   sudo nano /etc/prometheus/alert_rules.yml
   ```
2. Añade una regla de ejemplo:
   ```yaml
   groups:
     - name: Example Alerts
       rules:
         - alert: HighCPUUsage
           expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
           for: 2m
           labels:
             severity: critical
           annotations:
             summary: "Uso alto de CPU"
             description: "El uso de CPU está por encima del 80% durante 2 minutos en la instancia {{ $labels.instance }}."
   ```
3. Reinicia Prometheus:
   ```bash
   sudo systemctl restart prometheus
   ```

---

## 4. Verificar Alertas
1. Abre la interfaz web de Prometheus en `http://<tu-ip>:9090`.
2. Ve a la sección **Alerts** para verificar las alertas configuradas.
3. Comprueba que Alertmanager esté recibiendo las alertas en `http://<tu-ip>:9093`.

---

¡Listo! Ahora tienes un sistema básico de alertas configurado en Prometheus y Alertmanager. Puedes personalizarlo para que se adapte a tus necesidades.
