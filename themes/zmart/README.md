# ZMart Keycloak Theme

Este es el tema personalizado de ZMart para Keycloak, diseñado con un enfoque moderno que incluye modo claro/oscuro, efectos de glassmorphism y diseño responsivo.

## 📁 Estructura del Tema

```
themes/zmart/
├── README.md                    # Este archivo
├── account/                     # Módulo de gestión de cuenta
│   ├── README.md               # Documentación del módulo account
│   ├── theme.properties        # Configuración del tema account
│   └── resources/
│       └── css/
│           └── account.css     # Estilos para páginas de cuenta
├── admin/                      # Módulo de administración
│   ├── README.md               # Documentación del módulo admin
│   ├── theme.properties        # Configuración del tema admin
│   └── resources/
│       └── css/
│           └── admin.css       # Estilos para consola de administración
├── email/                      # Módulo de plantillas de email
│   ├── README.md               # Documentación del módulo email
│   ├── theme.properties        # Configuración del tema email
│   ├── html/                   # Plantillas HTML de emails
│   │   ├── admin-invitation.ftl
│   │   ├── admin-user-invitation.ftl
│   │   ├── email-verification.ftl
│   │   └── password-reset.ftl
│   └── resources/
│       └── css/
│           └── email.css       # Estilos para emails
└── login/                      # Módulo de autenticación
    ├── README.md               # Documentación del módulo login
    ├── theme.properties        # Configuración del tema login
    ├── demo-login.html         # Demo de referencia del diseño
    ├── error.ftl               # Página de errores
    ├── info.ftl                # Página de información
    ├── invitation-register.ftl # Registro por invitación
    ├── link-github-account.ftl # Enlace cuenta GitHub
    ├── link-google-account.ftl # Enlace cuenta Google
    ├── login-config-totp.ftl   # Configuración 2FA
    ├── login-otp.ftl           # Verificación OTP
    ├── login-reset-password.ftl # Reset de contraseña
    ├── login-update-password.ftl # Actualizar contraseña
    ├── login-update-profile.ftl # Actualizar perfil
    ├── login-verify-email.ftl  # Verificación de email
    ├── login.ftl               # Página de login principal
    ├── register.ftl            # Página de registro
    ├── template.ftl            # Plantilla base
    └── resources/
        ├── css/
        │   └── styles.css      # Estilos principales del login
        └── img/
            └── background.png  # Imagen de fondo
```

## 🎨 Sistema de Diseño

### Colores Principales
- **Brick Orange**: `#c2410c` (primary)
- **Blue**: `#2563eb` (secondary)
- **Gradientes**: Combinaciones de brick y blue para efectos visuales

### Características del Diseño
- **Glassmorphism**: Efectos de vidrio con `backdrop-filter: blur(12px)`
- **Modo Claro/Oscuro**: Sistema automático con toggle manual
- **Tipografía**: Google Fonts Inter (400, 500, 600, 700, 800)
- **Diseño Responsivo**: Mobile-first con breakpoints adaptativos
- **Layout de Dos Columnas**: Hero section + formulario

## 🚀 Instalación y Uso

1. **Ubicación**: Este tema debe estar en `{KEYCLOAK_HOME}/themes/zmart/`
2. **Configuración**: En la consola de administración de Keycloak, selecciona "zmart" como tema
3. **Módulos**: Cada módulo (login, account, admin, email) puede configurarse independientemente

## 📦 Módulos Disponibles

### 🔐 Login Module
Maneja todas las páginas relacionadas con autenticación:
- Inicio de sesión
- Registro de usuarios
- Reset de contraseña
- Enlaces de cuentas sociales
- Manejo de errores

### 👤 Account Module
Gestión de cuenta de usuario:
- Perfil de usuario
- Configuración de seguridad
- Gestión de sesiones
- Aplicaciones vinculadas

### ⚙️ Admin Module
Consola de administración personalizada:
- Dashboard administrativo
- Gestión de usuarios
- Configuración del realm
- Monitoreo del sistema

### 📧 Email Module
Plantillas de correo electrónico:
- Verificación de email
- Reset de contraseña
- Invitaciones administrativas
- Notificaciones del sistema

## � Flujo de Creación de Usuarios

El siguiente diagrama muestra los diferentes flujos de creación de usuarios en el sistema ZMart:

```mermaid
flowchart TD
    Start([Inicio]) --> Choice{Tipo de Registro}
    
    %% Flujo de Auto-registro
    Choice -->|Auto-registro| SelfReg[📝 Página de Registro]
    SelfReg --> SelfForm[Completar Formulario<br/>• Nombre y Apellido<br/>• Email<br/>• Usuario<br/>• Contraseña]
    SelfForm --> SelfSubmit[Enviar Formulario]
    SelfSubmit --> EmailVerify[📧 Email de Verificación]
    EmailVerify --> VerifyClick[Usuario hace clic en enlace]
    VerifyClick --> AccountActive1[✅ Cuenta Activada]
    
    %% Flujo de Invitación Administrativa
    Choice -->|Invitación Admin| AdminInvite[👨‍💼 Admin envía invitación]
    AdminInvite --> AdminEmail[📧 Email de Invitación<br/>admin-invitation.ftl]
    AdminEmail --> InviteClick[Usuario hace clic en enlace]
    InviteClick --> InviteReg[📝 Registro por Invitación<br/>invitation-register.ftl]
    InviteReg --> InviteForm[Completar Información<br/>• Datos personales<br/>• Contraseña]
    InviteForm --> AccountActive2[✅ Cuenta Activada]
    
    %% Flujo con Proveedores Sociales
    Choice -->|Con Cuenta Social| SocialChoice{Proveedor Social}
    SocialChoice -->|Google| GoogleAuth[🔗 Autenticación Google<br/>link-google-account.ftl]
    SocialChoice -->|GitHub| GitHubAuth[🔗 Autenticación GitHub<br/>link-github-account.ftl]
    
    GoogleAuth --> GoogleComplete[Completar Perfil]
    GitHubAuth --> GitHubComplete[Completar Perfil]
    GoogleComplete --> AccountActive3[✅ Cuenta Activada]
    GitHubComplete --> AccountActive3
    
    %% Estados finales
    AccountActive1 --> LoginPage[🔐 Página de Login<br/>login.ftl]
    AccountActive2 --> LoginPage
    AccountActive3 --> LoginPage
    LoginPage --> Dashboard[📊 Dashboard/Aplicación]
    
    %% Flujo de errores
    SelfSubmit -->|Error| ErrorPage[❌ Página de Error<br/>error.ftl]
    VerifyClick -->|Link expirado| ErrorPage
    InviteClick -->|Link expirado| ErrorPage
    ErrorPage --> Choice
    
    %% Reset de contraseña
    LoginPage -->|Olvidé contraseña| ResetPage[🔑 Reset Contraseña<br/>login-reset-password.ftl]
    ResetPage --> ResetEmail[📧 Email de Reset<br/>password-reset.ftl]
    ResetEmail --> NewPassword[Establecer Nueva Contraseña]
    NewPassword --> LoginPage
    
    %% Estilos
    classDef pageStyle fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef emailStyle fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef successStyle fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef errorStyle fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef processStyle fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    
    class SelfReg,InviteReg,LoginPage,ResetPage,GoogleAuth,GitHubAuth pageStyle
    class EmailVerify,AdminEmail,ResetEmail emailStyle
    class AccountActive1,AccountActive2,AccountActive3,Dashboard successStyle
    class ErrorPage errorStyle
    class SelfForm,InviteForm,GoogleComplete,GitHubComplete,NewPassword processStyle
```

### 📋 Descripción de Flujos

#### 🔐 Auto-registro (Flujo Estándar)
1. **Acceso**: Usuario visita la página de registro (`register.ftl`)
2. **Formulario**: Completa información personal y credenciales
3. **Verificación**: Recibe email de verificación (`email-verification.ftl`)
4. **Activación**: Hace clic en el enlace para activar la cuenta
5. **Acceso**: Puede iniciar sesión normalmente

#### 👨‍💼 Invitación Administrativa
1. **Invitación**: Administrador envía invitación desde la consola admin
2. **Email**: Usuario recibe email de invitación (`admin-invitation.ftl`)
3. **Registro**: Accede al formulario de registro por invitación (`invitation-register.ftl`)
4. **Completar**: Establece contraseña y completa perfil
5. **Activación**: Cuenta queda inmediatamente activa

#### 🔗 Registro con Proveedores Sociales
1. **Selección**: Usuario elige proveedor social (Google/GitHub)
2. **Autenticación**: Se redirige al proveedor para autenticación
3. **Enlace**: Sistema vincula la cuenta social (`link-*-account.ftl`)
4. **Perfil**: Usuario completa información adicional si es necesaria
5. **Activación**: Cuenta queda activa con enlace social

#### 🔑 Recuperación de Contraseña
1. **Solicitud**: Usuario solicita reset desde login (`login-reset-password.ftl`)
2. **Email**: Recibe enlace de recuperación (`password-reset.ftl`)
3. **Nueva contraseña**: Establece nueva contraseña
4. **Acceso**: Puede iniciar sesión con nuevas credenciales

### 🎨 Plantillas Involucradas

| Plantilla | Propósito | Módulo |
|-----------|-----------|---------|
| `register.ftl` | Registro estándar de usuarios | Login |
| `invitation-register.ftl` | Registro por invitación administrativa | Login |
| `link-google-account.ftl` | Enlace de cuenta Google | Login |
| `link-github-account.ftl` | Enlace de cuenta GitHub | Login |
| `login-reset-password.ftl` | Solicitud de reset de contraseña | Login |
| `error.ftl` | Manejo de errores en el proceso | Login |
| `email-verification.ftl` | Email de verificación de cuenta | Email |
| `admin-invitation.ftl` | Email de invitación administrativa | Email |
| `password-reset.ftl` | Email de reset de contraseña | Email |

## �🛠️ Personalización

### Variables CSS
El tema utiliza CSS Custom Properties para fácil personalización:

```css
:root {
  --brick-700: #c2410c;  /* Color principal */
  --brick-600: #dc2626;  /* Variante */
  --blue-600: #2563eb;   /* Color secundario */
  --bg-primary: #ffffff; /* Fondo principal */
  --text-primary: #1f2937; /* Texto principal */
}
```

### Modo Oscuro
Las variables se adaptan automáticamente:

```css
[data-theme="dark"] {
  --bg-primary: #1f2937;
  --text-primary: #f9fafb;
}
```

## 📱 Compatibilidad

- **Navegadores**: Chrome, Firefox, Safari, Edge (últimas 2 versiones)
- **Dispositivos**: Desktop, tablet, móvil
- **Accesibilidad**: WCAG 2.1 AA compliant
- **Keycloak**: Versiones 20.x y superiores

## 🔧 Desarrollo

### Estructura de Archivos
- **`.ftl`**: Plantillas FreeMarker para HTML
- **`.css`**: Hojas de estilo
- **`.properties`**: Configuración de temas
- **`.html`**: Demos y referencias

### Mejores Prácticas
1. Mantén la consistencia con el sistema de diseño base
2. Usa las variables CSS definidas para colores y spacing
3. Prueba en modo claro y oscuro
4. Verifica la responsividad en diferentes dispositivos
5. Mantén la accesibilidad (ARIA labels, contraste, etc.)

## 📝 Notas de Versión

### v1.0.0 (Actual)
- Sistema de diseño moderno con glassmorphism
- Soporte completo para modo claro/oscuro
- Plantillas simplificadas y optimizadas
- Diseño responsivo mejorado
- Documentación completa de módulos

## 🐛 Troubleshooting

### Errores Comunes de Configuración

#### ❌ Parameter 'client_id' not present
**Síntoma**: `Parameter 'client_id' not present or present multiple times`

**Soluciones**:
1. **Verificar configuración del cliente**:
   ```bash
   # En la consola de administración
   Clients > [tu-cliente] > Settings
   # Asegurar que Client ID esté configurado correctamente
   ```

2. **Revisar URLs de redirect**:
   ```
   Valid Redirect URIs: http://localhost:8080/*
   Web Origins: http://localhost:8080
   ```

3. **Verificar configuración de la aplicación**:
   ```javascript
   // Ejemplo configuración correcta
   const keycloak = new Keycloak({
     url: 'http://localhost:8080',
     realm: 'zmart',
     clientId: 'tu-client-id' // Debe coincidir exactamente
   });
   ```

#### ❌ Invalid Code / Cookie Not Found
**Síntoma**: `error="invalid_code"` o `error="cookie_not_found"`

**Soluciones**:
1. **Limpiar cookies del navegador**:
   - Borrar cookies de `localhost:8080`
   - Usar modo incógnito para testing

2. **Verificar configuración de sesión**:
   ```bash
   # En Realm Settings > Sessions
   SSO Session Idle: 30 minutos
   SSO Session Max: 10 horas
   ```

3. **Revisar configuración de HTTPS**:
   ```bash
   # Para desarrollo local
   --hostname-strict=false
   --hostname=localhost
   ```

#### ❌ Tema no se aplica correctamente
**Síntomas**: Estilos por defecto de Keycloak aparecen en lugar del tema ZMart

**Soluciones**:
1. **Verificar ubicación del tema**:
   ```bash
   # Estructura correcta
   {KEYCLOAK_HOME}/themes/zmart/
   ├── login/
   ├── account/
   ├── admin/
   └── email/
   ```

2. **Limpiar caché de Keycloak**:
   ```bash
   # Reiniciar Keycloak completamente
   make restart
   
   # O limpiar caché manualmente
   rm -rf {KEYCLOAK_HOME}/standalone/tmp/
   ```

3. **Verificar selección de tema en realm**:
   ```bash
   # En Realm Settings > Themes
   Login Theme: zmart
   Account Theme: zmart
   Admin Console Theme: zmart
   Email Theme: zmart
   ```

### Comandos de Diagnóstico

#### Verificar estado del contenedor
```bash
# Ver logs en tiempo real
make logs

# Verificar estado de servicios
make status

# Reiniciar servicios
make restart
```

#### Verificar configuración del realm
```bash
# Exportar configuración actual
make realm-export REALM=zmart.json

# Verificar configuración
cat config/realms/zmart.json | jq '.themes'
```

#### Testing del tema
```bash
# Construir y probar
make build
make test-theme

# Verificar archivos del tema
ls -la themes/zmart/*/
```

### Logs de Debugging

#### Habilitar logging detallado
```bash
# En keycloak.conf o variables de entorno
KC_LOG_LEVEL=DEBUG
KC_LOG_CONSOLE_COLOR=true

# Para temas específicamente
KC_LOG_THEME_DEBUG=true
```

#### Logs importantes a revisar
```bash
# Errores de autenticación
grep "LOGIN_ERROR" logs/keycloak.log

# Problemas de configuración
grep "WARN.*theme" logs/keycloak.log

# Errores de carga de recursos
grep "404.*css\|js" logs/keycloak.log
```

### Validación de Configuración

#### Checklist de verificación
- [ ] Tema ZMart está en la ubicación correcta
- [ ] Permisos de archivos son correctos (755 para directorios, 644 para archivos)
- [ ] Realm tiene el tema seleccionado correctamente
- [ ] Cliente tiene URLs de redirect configuradas
- [ ] No hay conflictos de caché del navegador
- [ ] Keycloak está ejecutándose sin errores críticos

#### URLs de testing
```bash
# Login page
http://localhost:8080/realms/zmart/protocol/openid-connect/auth?client_id=account

# Account management
http://localhost:8080/realms/zmart/account

# Admin console
http://localhost:8080/admin/zmart/console
```

### Problemas Conocidos

#### 🔧 Problemas de redirección desde otras páginas de Keycloak
**Síntoma**: Login funciona directamente pero falla cuando redirige desde otras páginas
**Causa**: Plantillas FTL faltantes o configuración incorrecta en theme.properties
**Solución**:
```bash
# Verificar que todas las plantillas FTL estén presentes
ls themes/zmart/login/*.ftl

# Reiniciar Keycloak después de añadir plantillas
make restart

# Plantillas críticas para redirecciones:
# - login-update-password.ftl
# - login-update-profile.ftl  
# - login-verify-email.ftl
# - login-otp.ftl
# - info.ftl
```

#### 🔧 Realm API retorna 404 después de import exitoso
**Síntoma**: `curl http://localhost:8080/realms/zmart/.well-known/openid_configuration` retorna 404
**Causa**: La importación de realm puede tardar algunos minutos en propagarse
**Solución**: 
```bash
# Esperar 2-3 minutos después del import
# Usar el admin console para verificar: http://localhost:8080/admin/
# Verificar que el realm aparece en el dropdown superior izquierdo
```

#### 🔧 Glassmorphism no funciona en navegadores antiguos
**Solución**: El tema incluye fallbacks automáticos para navegadores sin soporte de `backdrop-filter`

#### 🔧 Modo oscuro no persiste
**Solución**: Verificar que JavaScript esté habilitado y localStorage funcione correctamente

#### 🔧 Responsive layout roto en móvil
**Solución**: Limpiar caché del navegador y verificar que CSS se carga completamente

## 🤝 Contribución

Para contribuir al tema:
1. Sigue las guías de estilo establecidas
2. Documenta cambios significativos
3. Prueba en múltiples navegadores y dispositivos
4. Mantén la compatibilidad con versiones anteriores

## 📞 Soporte

Para soporte o preguntas sobre el tema:
- **Issues**: Reportar problemas en el repositorio
- **Logs**: Incluir siempre logs relevantes en reportes de errores
- **Configuración**: Compartir configuración relevante (sin credenciales)
- **Ambiente**: Especificar versión de Keycloak y navegador usado