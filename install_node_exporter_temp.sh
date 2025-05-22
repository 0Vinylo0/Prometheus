#!/bin/bash
set -e

echo "[*] Instalando node_exporter y soporte de temperatura..."

# Instalar node_exporter desde APT
apt update
apt install -y prometheus-node-exporter lm-sensors

# Configurar sensores
yes | sensors-detect || true
modprobe coretemp

# Crear script para exportar temperaturas físicas (Package id X)
mkdir -p /var/lib/prometheus/node-exporter

cat <<EOF >/usr/local/bin/export-temp.sh
#!/bin/bash
OUT="/var/lib/prometheus/node-exporter/temp.prom"
> "$OUT"
echo "# HELP node_custom_temp_celsius CPU package temperature in Celsius" >> "$OUT"
echo "# TYPE node_custom_temp_celsius gauge" >> "$OUT"
INDEX=0
sensors | grep 'Package id' | while read -r line; do
    TEMP=\$(echo "\$line" | awk '{print \$4}' | tr -d '+°C')
    echo "node_custom_temp_celsius{cpu=\"\$INDEX\"} \$TEMP" >> "\$OUT"
    INDEX=\$((INDEX + 1))
done
EOF

chmod +x /usr/local/bin/export-temp.sh

# Añadir al cron
(crontab -l ; echo "* * * * * /usr/local/bin/export-temp.sh") | crontab -

systemctl restart prometheus-node-exporter

echo "[*] node_exporter con temperatura instalado correctamente."
