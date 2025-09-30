# Quick Start Guide

Este es un resumen rápido para comenzar con el servicio IAM.

## Pasos Rápidos

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/agustin-rios/iam.git
   cd iam
   ```

2. **Iniciar los servicios**
   ```bash
   docker compose up -d
   ```

3. **Esperar a que los servicios estén listos** (1-2 minutos)
   ```bash
   docker compose ps
   ```

4. **Acceder a Keycloak**
   - URL: http://localhost:8080
   - Usuario: `admin`
   - Contraseña: `admin`

## Servicios

- **Keycloak**: http://localhost:8080
- **PostgreSQL**: localhost:5432

## Comandos Útiles

```bash
# Ver logs
docker compose logs -f

# Detener servicios
docker compose down

# Detener y eliminar datos
docker compose down -v
```

## Configuración Personalizada

Copia y modifica el archivo de entorno:
```bash
cp .env.example .env
```

Luego edita `.env` con tus valores personalizados.

## Solución de Problemas

Si los servicios no inician correctamente:

1. Verifica que Docker esté corriendo
2. Asegúrate de que los puertos 8080 y 5432 estén disponibles
3. Revisa los logs: `docker compose logs`

Para más información, consulta el [README.md](README.md) completo.
