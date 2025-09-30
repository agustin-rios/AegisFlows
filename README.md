# AegisFlows - Identity and Access Management Service

Estudio del uso de Keycloak como servicio para manejar profiles y centralizar servicios IAM.

Este proyecto proporciona un servicio IAM listo para ejecutar utilizando Keycloak 26 y PostgreSQL 15 con Docker.

## Requisitos Previos

- Docker instalado (versión 20.10 o superior)
- Docker Compose instalado (versión 2.0 o superior)
- Al menos 2GB de RAM disponible para los contenedores

## Componentes

- **Keycloak 26**: Sistema de gestión de identidad y acceso de código abierto
- **PostgreSQL 15**: Base de datos para persistencia de datos de Keycloak

## Inicio Rápido

### 1. Clonar el repositorio

```bash
git clone https://github.com/agustin-rios/AegisFlows.git
cd AegisFlows
```

### 2. Instalación automática

```bash
make install
```

### 3. Configurar variables de entorno (recomendado)

El comando `make install` crea automáticamente un archivo `.env` desde `.env.example`. Edítalo según sea necesario:

```bash
nano .env  # o tu editor preferido
```

Variables disponibles:
- `POSTGRES_DB`: Nombre de la base de datos (default: keycloak)
- `POSTGRES_USER`: Usuario de PostgreSQL (default: keycloak)
- `POSTGRES_PASSWORD`: Contraseña de PostgreSQL (default: keycloak)
- `DB_PORT`: Puerto del servicio PostgreSQL expuesto localmente (default: 5432)
- `KEYCLOAK_ADMIN`: Usuario administrador de Keycloak (default: admin)
- `KEYCLOAK_ADMIN_PASSWORD`: Contraseña del administrador (default: admin)
- `KC_HOSTNAME`: Hostname para Keycloak (default: localhost)
- `KEYCLOAK_PORT`: Puerto HTTP de Keycloak (default: 8080)
- `KEYCLOAK_MGMT_PORT`: Puerto de gestión y métricas (default: 9000)

⚠️ **Importante**: Cambia las contraseñas predeterminadas en entornos de producción.

### 4. Validar la configuración

```bash
make validate
```

### 5. Iniciar los servicios

```bash
# Desarrollo
make dev

# O manualmente
docker compose up -d
```

### 4. Verificar el estado de los servicios

```bash
docker compose ps
```

Los servicios deberían estar en estado "healthy" después de aproximadamente 1-2 minutos.

### 5. Acceder a Keycloak

Abre tu navegador y accede a:

```
http://localhost:8080
```

Credenciales por defecto:
- Usuario: `admin`
- Contraseña: `admin`

## Comandos Útiles

Este proyecto incluye un Makefile con comandos convenientes:

### Comandos principales

```bash
make help          # Mostrar ayuda
make dev           # Iniciar entorno de desarrollo  
make prod          # Iniciar entorno de producción
make monitoring    # Iniciar con stack de monitoreo
make stop          # Detener servicios
make clean         # Detener y eliminar datos (¡PÉRDIDA DE DATOS!)
```

### Logs y monitoreo

```bash
make logs          # Ver logs de todos los servicios
make logs-keycloak # Ver logs solo de Keycloak
make logs-postgres # Ver logs solo de PostgreSQL
make status        # Estado de los servicios
make health        # Verificar salud de los servicios
```

### Operaciones de base de datos

```bash
make backup        # Crear backup de la base de datos
make restore BACKUP_FILE=archivo.sql  # Restaurar backup
make psql          # Conectar a PostgreSQL
```

### Comandos legacy (Docker Compose directo)

```bash
# Ver logs
docker compose logs -f

# Detener servicios  
docker compose down

# Detener y eliminar datos
docker compose down -v

# Reiniciar servicio específico
docker compose restart keycloak
```

## Puertos Expuestos

- **8080**: Consola de administración de Keycloak y API
- **9000**: Puerto de métricas y administración interna de Keycloak
- **5432**: PostgreSQL (opcional, para acceso directo a la base de datos)

## Arquitectura

```
┌─────────────────┐
│   Keycloak 26   │
│   Port: 8080    │
└────────┬────────┘
         │
         │ JDBC
         │
┌────────▼────────┐
│ PostgreSQL 15   │
│   Port: 5432    │
└─────────────────┘
```

## Configuración Avanzada

### Modo Producción

Activa el perfil `prod` para construir la imagen optimizada definida en `Dockerfile`:

```bash
docker compose --profile prod up -d keycloak-prod
```

Al usar la imagen optimizada asegúrate de:
- Configurar certificados SSL/TLS y un proxy inverso
- Ajustar variables de entorno y contraseñas seguras
- Definir límites de recursos y monitoreo
- Establecer un plan de backups para la base de datos

### Personalización

Puedes personalizar Keycloak mediante:
- Variables de entorno adicionales (ver documentación oficial)
- Archivos JSON en `config/realms/` que se importan automáticamente al iniciar
- Temas personalizados dentro de `themes/`
- Ajustes de base de datos editando `scripts/init-db.sh`
- Providers personalizados montados en `/opt/keycloak/providers`

## Health Checks

Los servicios exponen endpoints de salud para integrarlos con tu plataforma de observabilidad:

- **PostgreSQL**: El healthcheck de Compose usa `pg_isready` para validar la conexión
- **Keycloak**: Con `KC_HEALTH_ENABLED=true` queda disponible `/health/ready`

## Troubleshooting

### Keycloak no inicia

1. Verifica que PostgreSQL esté healthy: `docker compose ps`
2. Revisa los logs: `docker compose logs keycloak`
3. Asegúrate de tener suficiente memoria disponible

### No puedo acceder a localhost:8080

1. Verifica que el contenedor esté corriendo: `docker compose ps`
2. Verifica que el puerto no esté en uso: `lsof -i :8080` (Linux/Mac) o `netstat -ano | findstr :8080` (Windows)
3. Prueba acceder a `http://127.0.0.1:8080`

### Error de conexión a la base de datos

1. Verifica que PostgreSQL esté healthy
2. Verifica las variables de entorno en `.env`
3. Reinicia los servicios: `docker compose restart`

## Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Haz fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## Recursos Adicionales

- [Documentación oficial de Keycloak](https://www.keycloak.org/documentation)
- [Guías de Keycloak](https://www.keycloak.org/guides)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/15/)
- [Docker Documentation](https://docs.docker.com/)

## Contacto

Agustin Rios - [@agustin-rios](https://github.com/agustin-rios)

Project Link: [https://github.com/agustin-rios/AegisFlows](https://github.com/agustin-rios/AegisFlows)
