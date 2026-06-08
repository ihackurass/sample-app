#!/bin/bash

# ── Limpieza previa ──────────────────────────────────────────────
rm -rf tempdir
docker rm -f samplerunning 2>/dev/null

# ── Crear directorios temporales ─────────────────────────────────
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

# ── Copiar archivos ──────────────────────────────────────────────
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# ── Crear Dockerfile (> para crear nuevo, no append) ─────────────
echo "FROM python" > tempdir/Dockerfile
echo "RUN pip install --progress-bar off flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 5050" >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py" >> tempdir/Dockerfile

# ── Construir el contenedor Docker ───────────────────────────────
cd tempdir
docker build -t sampleapp:latest .

# ── Ejecutar el contenedor ───────────────────────────────────────
docker run --privileged -t -d -p 5050:5050 --name samplerunning sampleapp

# ── Verificar contenedores en ejecución ──────────────────────────
docker ps -a
