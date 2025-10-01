# 🎯 ZMart Social Registration Flow - Keycloak Native

Este documento explica el flujo **nativo de Keycloak** para registro de usuarios con vinculación social automática - **sin scripts externos**.

## 📋 Resumen del Flujo Nativo

### **Para Administradores:**
1. **Crear Usuario**: Via Admin Console crear usuario con email
2. **Required Actions**: Keycloak automáticamente asigna acciones requeridas
3. **Email Automático**: Keycloak envía invitación usando templates personalizados

### **Para Usuarios:**
1. **📧 Recibe Email**: Email automático de Keycloak con template ZMart
2. **✅ Verifica Email**: Confirma email via enlace
3. **🔗 Opciones Sociales**: Templates muestran botones Google/GitHub
4. **🔗 Vinculación**: Authentication Flows manejan la vinculación
5. **📝 Completa Perfil**: Required Actions guían el resto del proceso

## 🚀 Implementación Nativa de Keycloak

### 1. **Admin Console - Crear Usuario**

**Ubicación**: `http://localhost:8080/admin` → Users → Add User

**Proceso Nativo**:
- Administrador crea usuario con email en Admin Console
- Keycloak automáticamente asigna Required Actions:
  - `VERIFY_EMAIL` (verificar email)
  - `UPDATE_PROFILE` (actualizar perfil)
  - `TERMS_AND_CONDITIONS` (aceptar términos)

### 2. **Email Automático de Keycloak**

**Template Personalizado**: `email-verification.ftl`
- Keycloak envía email usando nuestro template ZMart
- Email incluye enlace de verificación automático
- **Sin scripts**: Todo es configuración nativa

### 3. **Authentication Flows Nativos**

```bash
# Usando Make (recomendado)
make invite-user EMAIL=usuario@ejemplo.com

# O directamente con el script
./scripts/invite-user-admin.sh usuario@ejemplo.com
```

**Lo que sucede:**
- Se crea un usuario en Keycloak con estado "no verificado"
- Se configuran automáticamente los **Required Actions**:
  - `VERIFY_EMAIL` (verificar email)
  - `UPDATE_PROFILE` (actualizar perfil)
  - `TERMS_AND_CONDITIONS` (términos y condiciones)
- Se envía email de invitación usando template personalizado
- Se establecen atributos especiales para el flujo social:
  - `requires_google_link: true`
  - `requires_github_link: optional`

### 2. Usuario Recibe Email de Invitación

El usuario recibe un email con:
- **Información clara** sobre el proceso
- **Tabla explicativa** de cada paso
- **Botón de acción** para comenzar registro
- **Explicación de beneficios** de vinculación social

### 3. Flujo de Registro con Vinculación Social

#### **Paso 1: Verificación de Email**
- Usuario hace clic en el enlace del email
- Keycloak verifica el email automáticamente
- Usuario ve página de confirmación

#### **Paso 2: Vinculación de Google (OBLIGATORIA)**
- Keycloak presenta página personalizada `link-google-account.ftl`
- Usuario ve:
  - Indicador de progreso (Paso 1 de 3)
  - Explicación de por qué es necesario Google
  - Botón "Conectar Cuenta de Google"
- Al hacer clic, se redirige a Google OAuth
- Después de autorizar, regresa con cuenta vinculada

#### **Paso 3: Vinculación de GitHub (OPCIONAL)**
- Keycloak presenta página personalizada `link-github-account.ftl`
- Usuario ve:
  - Indicador de progreso (Paso 2 de 3)
  - Explicación de beneficios de GitHub
  - Opciones: "Conectar GitHub" o "Omitir por Ahora"
- Si conecta: OAuth con GitHub
- Si omite: continúa al siguiente paso

#### **Paso 4: Completar Perfil**
- Keycloak presenta formulario de perfil estándar
- Usuario llena información personal
- Acepta términos y condiciones
- Completa el registro

## 🔧 Configuración Técnica

### Required Actions Configurados Automáticamente

En el realm configuration (`zmart-social-flow.json`):

```json
"requiredActions": [
  {
    "alias": "VERIFY_EMAIL",
    "name": "Verify Email",
    "defaultAction": true,
    "priority": 10
  },
  {
    "alias": "UPDATE_PROFILE", 
    "name": "Update Profile",
    "defaultAction": true,
    "priority": 20
  },
  {
    "alias": "TERMS_AND_CONDITIONS",
    "name": "Terms and Conditions", 
    "defaultAction": true,
    "priority": 30
  }
]
```

### Identity Providers para Social Login

```json
"identityProviders": [
  {
    "alias": "google",
    "providerId": "google",
    "enabled": true,
    "updateProfileFirstLoginMode": "on",
    "firstBrokerLoginFlowAlias": "Social Registration Flow"
  },
  {
    "alias": "github",
    "providerId": "github", 
    "enabled": true,
    "updateProfileFirstLoginMode": "on",
    "firstBrokerLoginFlowAlias": "Social Registration Flow"
  }
]
```

### Authentication Flows Personalizados

- **Social Registration Flow**: Maneja nuevos usuarios de proveedores sociales
- **Handle Existing Account**: Maneja casos donde ya existe una cuenta
- **ZMart Registration**: Flow de registro estándar con pasos sociales

## 📧 Templates de Email

### Template de Invitación (`admin-user-invitation.ftl`)
- Diseño profesional con branding ZMart
- Explicación clara del proceso paso a paso
- Tabla detallada de cada acción requerida
- Información sobre beneficios de vinculación social
- Políticas de privacidad y soporte

### Template de Verificación (`email-verification.ftl`)
- Confirmación de registro exitoso
- Instrucciones para siguiente paso
- Información de contacto y soporte

## 🎨 Templates de Páginas

### Login Templates Personalizados
- `link-google-account.ftl`: Página de vinculación Google
- `link-github-account.ftl`: Página de vinculación GitHub
- `register.ftl`: Página de registro con indicadores de progreso

### Características de UI/UX
- **Indicadores de progreso** visuales
- **Explicaciones claras** de cada paso
- **Diseño responsivo** para móviles
- **Branding consistente** ZMart
- **Animaciones suaves** y transiciones

## 📊 Monitoreo y Administración

### Consola de Administración
- **URL**: `http://localhost:8080/admin/master/console/#/zmart/users`
- **Filtrar por**: Estado de registro, Required Actions pendientes
- **Monitorear**: Progreso de vinculación social por usuario

### Comandos Útiles

```bash
# Invitar usuario único
make invite-user EMAIL=user@example.com

# Ver logs del sistema
make logs

# Estado de servicios
make status

# Acceder a base de datos
make psql
```

## 🔒 Seguridad y Privacidad

### Protección de Datos
- Solo se accede a información básica de perfiles sociales
- Usuarios pueden desvincular cuentas en cualquier momento
- Datos encriptados en tránsito y reposo
- Cumplimiento con políticas de privacidad

### OAuth Security
- Secrets gestionados via API (no archivos)
- Tokens de acceso con expiración automática
- Scope mínimo necesario para cada proveedor
- Validación de email obligatoria

## 🚨 Resolución de Problemas

### Usuario No Recibe Email
1. Verificar configuración SMTP en realm
2. Revisar logs de Keycloak: `make logs-keycloak`
3. Confirmar que email no está en spam

### Error en Vinculación Social
1. Verificar credentials OAuth en `.env`
2. Confirmar redirect URIs en providers
3. Revistar logs de autenticación

### Usuario Queda en Estado Pendiente
1. Revisar Required Actions en Admin Console
2. Forzar reenvío de email si es necesario
3. Verificar configuración de Authentication Flows

## 📞 Soporte

Para problemas técnicos:
- **Email**: support@zmart.com  
- **Documentación**: [README.md](../README.md)
- **Issues**: GitHub repository issues

---

**🎯 Resultado Final**: Sistema completamente automatizado donde administradores invitan usuarios por email, y Keycloak maneja automáticamente todo el flujo de vinculación social sin scripts externos.