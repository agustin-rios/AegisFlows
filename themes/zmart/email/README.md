# Email Module - ZMart Theme

El módulo de email proporciona plantillas HTML personalizadas para todos los correos electrónicos enviados por Keycloak.

## 📁 Estructura de Archivos

```text
email/
├── README.md                       # Este archivo
├── theme.properties               # Configuración del tema
├── html/                          # Plantillas HTML de emails
│   ├── admin-invitation.ftl       # Invitación administrativa 
│   ├── admin-user-invitation.ftl  # Invitación de usuario
│   ├── email-verification.ftl     # Verificación de email
│   └── password-reset.ftl         # Reset de contraseña
└── resources/
    └── css/
        └── email.css              # Estilos para emails
```

## 🎯 Propósito

Este módulo garantiza que todos los emails enviados por Keycloak mantengan la coherencia visual con el tema ZMart:

- **Verificación de email**: Confirmación de nuevas cuentas
- **Reset de contraseña**: Recuperación de acceso
- **Invitaciones administrativas**: Registro de nuevos usuarios
- **Notificaciones del sistema**: Alertas y comunicaciones

## 🎨 Sistema de Diseño de Emails

### Adaptación para Email
Los emails requieren técnicas CSS específicas debido a las limitaciones de los clientes de correo:

```css
/* Compatibilidad con clientes de email */
table, td, p, a, li, blockquote {
  -webkit-text-size-adjust: 100%;
  -ms-text-size-adjust: 100%;
}

/* Compatibilidad con Outlook */
table, td {
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
}

/* Imágenes responsivas */
img {
  -ms-interpolation-mode: bicubic;
  border: 0;
  height: auto;
  line-height: 100%;
  outline: none;
  text-decoration: none;
}
```

### Estructura de Email
```css
/* Container principal */
.email-container {
  max-width: 600px;
  margin: 0 auto;
  background-color: #ffffff;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Header con branding */
.email-header {
  background: linear-gradient(135deg, #c2410c 0%, #2563eb 100%);
  padding: 30px 20px;
  text-align: center;
}

/* Contenido principal */
.email-body {
  padding: 40px 30px;
  background-color: #ffffff;
}

/* Footer informativo */
.email-footer {
  background-color: #f8fafc;
  padding: 30px 20px;
  text-align: center;
  border-top: 1px solid #e5e7eb;
}
```

## 📧 Plantillas HTML (FTL Files)

### email-verification.ftl
**Propósito**: Email de verificación para nuevas cuentas.

**Estructura**:
- Header con logo y branding ZMart
- Mensaje de bienvenida personalizado
- Botón CTA principal para verificación
- Información sobre expiración del enlace
- Footer con información de contacto

**Características**:
```html
<!-- Botón de verificación -->
<div class="btn-container">
    <a href="${link}" class="btn">${msg("emailVerificationButton")}</a>
</div>

<!-- Alert de expiración -->
<div class="alert alert-info">
    <strong>${msg("linkExpires")}</strong>
</div>
```

### password-reset.ftl
**Propósito**: Email para reset de contraseña.

**Características**:
- Mensaje de seguridad claro
- Botón CTA para reset
- Alertas de seguridad
- Instrucciones alternativas
- Información de contacto para soporte

**Elementos de seguridad**:
```html
<!-- Alert de seguridad -->
<div class="security-alert">
    <div class="icon">🔒</div>
    <h3>${msg("securityNotice")}</h3>
    <p>${msg("securityMessage")}</p>
</div>
```

### admin-invitation.ftl
**Propósito**: Invitación administrativa simplificada.

**Características**:
- Diseño limpio y profesional
- Mensaje de invitación claro
- Botón de acción principal
- Información sobre expiración
- Soporte contacto

### admin-user-invitation.ftl
**Propósito**: Invitación de usuario estándar.

**Características**:
- Similar a admin-invitation pero más orientado al usuario final
- Explicación del proceso de registro
- Enlaces de ayuda
- Términos y condiciones

## 🎨 Estilos CSS (email.css)

### Tipografía y Colores
```css
/* Tipografía base */
.email-container {
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.email-body h1 {
  color: #1f2937;
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 20px 0;
  line-height: 1.3;
}

.email-body p {
  color: #4b5563;
  font-size: 16px;
  line-height: 1.6;
  margin: 0 0 20px 0;
}

/* Lead text */
.email-body .lead {
  font-size: 18px;
  color: #374151;
  font-weight: 500;
}
```

### Botones CTA
```css
/* Botón principal */
.btn {
  display: inline-block;
  background: linear-gradient(135deg, #c2410c 0%, #2563eb 100%);
  color: #ffffff !important;
  text-decoration: none;
  padding: 16px 32px;
  border-radius: 8px;
  font-weight: 600;
  font-size: 16px;
  text-align: center;
  min-width: 200px;
  box-sizing: border-box;
}

.btn:hover {
  background: linear-gradient(135deg, #9a3412 0%, #1d4ed8 100%);
}

/* Container centrado */
.btn-container {
  text-align: center;
  margin: 30px 0;
}
```

### Alertas y Notificaciones
```css
/* Alert base */
.alert {
  border-radius: 8px;
  padding: 20px;
  margin: 20px 0;
  font-size: 15px;
}

/* Tipos de alert */
.alert-info {
  background-color: #eff6ff;
  border-left: 4px solid #2563eb;
  color: #1e40af;
}

.alert-success {
  background-color: #f0fdf4;
  border-left: 4px solid #10b981;
  color: #047857;
}

.alert-warning {
  background-color: #fffbeb;
  border-left: 4px solid #f59e0b;
  color: #d97706;
}

.alert-danger {
  background-color: #fef2f2;
  border-left: 4px solid #ef4444;
  color: #dc2626;
}
```

### Componentes Especiales
```css
/* Código de verificación */
.verification-code {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  border: 2px solid #2563eb;
  border-radius: 12px;
  padding: 25px;
  text-align: center;
  margin: 30px 0;
}

.verification-code .code {
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 32px;
  font-weight: 700;
  color: #2563eb;
  letter-spacing: 8px;
  margin: 10px 0;
  display: block;
}

/* Bloque de código */
.code-block {
  background-color: #f8fafc;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  padding: 16px;
  font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
  font-size: 14px;
  color: #1f2937;
  overflow-x: auto;
  margin: 20px 0;
}
```

### Tablas de Información
```css
/* Tabla de detalles de cuenta */
.account-details {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
  background-color: #ffffff;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.account-details th {
  background-color: #f8fafc;
  padding: 15px;
  text-align: left;
  font-weight: 600;
  color: #374151;
  font-size: 14px;
}

.account-details td {
  padding: 15px;
  border-bottom: 1px solid #e5e7eb;
  color: #4b5563;
  font-size: 15px;
}

.account-details tr:last-child td {
  border-bottom: none;
}
```

## 📱 Responsive Email Design

### Media Queries para Email
```css
/* Dispositivos móviles */
@media screen and (max-width: 600px) {
  .email-container {
    width: 100% !important;
    max-width: 100% !important;
  }
  
  .email-body {
    padding: 20px 15px !important;
  }
  
  .email-header {
    padding: 20px 15px !important;
  }
  
  .btn {
    display: block !important;
    width: 100% !important;
    box-sizing: border-box !important;
  }
  
  .verification-code .code {
    font-size: 24px !important;
    letter-spacing: 4px !important;
  }
}
```

### Adaptaciones Móviles
- Padding reducido en container principal
- Botones de ancho completo
- Tamaño de fuente ajustado
- Espaciado optimizado para pantallas pequeñas

## 🌙 Soporte de Modo Oscuro

### Dark Mode en Emails
```css
/* Soporte para modo oscuro */
@media (prefers-color-scheme: dark) {
  .email-container {
    background-color: #1f2937 !important;
  }
  
  .email-body {
    background-color: #1f2937 !important;
  }
  
  .email-body h1,
  .email-body h2 {
    color: #f9fafb !important;
  }
  
  .email-body p {
    color: #d1d5db !important;
  }
  
  .account-details {
    background-color: #374151 !important;
  }
  
  .account-details th {
    background-color: #4b5563 !important;
    color: #f3f4f6 !important;
  }
  
  .account-details td {
    color: #e5e7eb !important;
    border-bottom-color: #4b5563 !important;
  }
}
```

## 🔧 Configuración (theme.properties)

```properties
parent=base
import=common/keycloak

# Configuración de locales
locales=en,es,fr,de

# Templates específicos
templates=html

# Configuración de recursos
styles=css/email.css
```

## ✉️ Testing de Emails

### Clientes de Email Soportados
- **Gmail**: Web y aplicaciones móviles
- **Outlook**: Versiones web y desktop
- **Apple Mail**: macOS e iOS
- **Yahoo Mail**: Web y móvil
- **Thunderbird**: Desktop

### Herramientas de Testing
1. **Litmus**: Testing en múltiples clientes
2. **Email on Acid**: Previews y análisis
3. **Mailtrap**: Testing en desarrollo
4. **Browser DevTools**: Testing responsive

### Checklist de Testing
- [ ] Renderizado correcto en Gmail
- [ ] Compatibilidad con Outlook
- [ ] Responsive en móviles
- [ ] Links funcionando correctamente
- [ ] Colores consistentes
- [ ] Tipografía legible
- [ ] Imágenes optimizadas
- [ ] Texto alternativo en imágenes

## 🎯 Mejores Prácticas para Emails

### Estructura HTML
- Usar tablas para layout principal
- Inline CSS para máxima compatibilidad
- Evitar JavaScript
- Texto alternativo en todas las imágenes

### Contenido y Copywriting
- Asunto claro y directo
- Mensaje principal visible sin scroll
- CTA (Call to Action) único y prominente
- Información de contacto siempre presente

### Accesibilidad
- Contraste adecuado entre texto y fondo
- Tamaño de fuente mínimo 14px
- Links descriptivos
- Estructura semántica clara

### Performance
- Imágenes optimizadas y comprimidas
- CSS minificado
- Evitar fuentes externas pesadas
- Tiempo de carga rápido

## 🔒 Consideraciones de Seguridad

### Enlaces Seguros
- Todos los enlaces usan HTTPS
- Validación de tokens incorporada
- Expiración de enlaces definida
- No exposición de información sensible en URLs

### Información Personal
- Mínima información personal en emails
- Datos encriptados donde sea necesario
- Cumplimiento con GDPR/CCPA
- Opciones claras de unsubscribe

## 🔄 Localización

### Soporte Multi-idioma
```ftl
<!-- Mensajes localizados -->
<h1>${msg("emailVerificationBodyHeader", user.firstName!"")}</h1>
<p>${msg("emailVerificationBody")}</p>
<a href="${link}" class="btn">${msg("emailVerificationButton")}</a>
```

### Idiomas Soportados
- **English (en)**: Idioma por defecto
- **Español (es)**: Localización completa
- **Français (fr)**: Localización completa
- **Deutsch (de)**: Localización completa

## 📋 Checklist de Implementación

- [ ] Plantillas HTML creadas
- [ ] CSS optimizado para email
- [ ] Testing en múltiples clientes
- [ ] Responsive design verificado
- [ ] Localización implementada
- [ ] Links de seguridad funcionando
- [ ] Modo oscuro compatible
- [ ] Performance optimizada
- [ ] Accesibilidad validada
- [ ] Cumplimiento legal verificado

## 🔄 Historial de Cambios

### v1.0.0
- Plantillas de email simplificadas
- Diseño coherente con tema ZMart
- Soporte responsive completo
- Modo oscuro implementado
- Localización multi-idioma
- Optimización para múltiples clientes de email