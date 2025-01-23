# Instalación de Grafana

Grafana es una potente herramienta de visualización que se integra perfectamente con Prometheus para monitorear y analizar datos. A continuación, se detallan los pasos para instalar Grafana en tu sistema Linux.

---

## Instalación de Grafana

### 1. Agregar el Repositorio de Grafana
1. Instala los paquetes necesarios para administrar repositorios:
   ```bash
   sudo apt-get install -y software-properties-common
   ```
2. Agrega el repositorio oficial de Grafana:
   ```bash
   echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
   ```
3. Importa la clave GPG del repositorio:
   ```bash
   sudo wget -q -O /usr/share/keyrings/grafana.key https://packages.grafana.com/gpg.key
   ```

### 2. Instalar Grafana
1. Actualiza la lista de paquetes:
   ```bash
   sudo apt-get update
   ```
2. Instala Grafana:
   ```bash
   sudo apt-get install grafana
   ```

### 3. Iniciar y Habilitar Grafana
1. Inicia el servicio de Grafana:
   ```bash
   sudo systemctl start grafana-server
   ```
2. Habilita el servicio para que inicie automáticamente al arrancar el sistema:
   ```bash
   sudo systemctl enable grafana-server
   ```

### 4. Acceder a Grafana
1. Abre tu navegador y dirígete a `http://<tu-ip>:3000`.
2. Inicia sesión con las credenciales predeterminadas:
   - **Usuario:** `admin`
   - **Contraseña:** `admin`
3. Se te pedirá cambiar la contraseña al iniciar sesión por primera vez.

---

## Configuración Inicial

### Conectar Grafana a Prometheus
1. En el menú de Grafana, ve a **Configuration > Data Sources**.
2. Haz clic en **Add data source**.
3. Selecciona **Prometheus** como tipo de fuente de datos.
4. En el campo **URL**, ingresa:
   ```
   http://<tu-ip>:9090
   ```
5. Haz clic en **Save & Test** para verificar la conexión.

### Importar un Dashboard Predefinido
1. En el menú de Grafana, ve a **Dashboards > Import**.
2. Busca dashboards en [Grafana Dashboards](https://grafana.com/grafana/dashboards).
3. Ingresa el ID del dashboard y haz clic en **Load**.
4. Selecciona tu fuente de datos (Prometheus) y haz clic en **Import**.

---

¡Grafana está ahora configurado y listo para ser usado con Prometheus! Continúa personalizando tus dashboards y explorando las métricas recopiladas.
