# Account Module - ZMart Theme

El módulo de account maneja todas las páginas relacionadas con la gestión de la cuenta de usuario en Keycloak.

## 📁 Estructura de Archivos

```text
account/
├── README.md                   # Este archivo
├── theme.properties           # Configuración del tema
└── resources/
    └── css/
        └── account.css        # Hoja de estilos principal
```

## 🎯 Propósito

Este módulo proporciona las interfaces de usuario para que los usuarios finales gestionen sus cuentas, incluyendo:

- **Perfil de usuario**: Edición de información personal
- **Configuración de seguridad**: Gestión de contraseñas y 2FA
- **Sesiones activas**: Visualización y gestión de sesiones
- **Aplicaciones vinculadas**: Gestión de aplicaciones autorizadas
- **Consentimientos**: Revisión y revocación de permisos

## 🎨 Sistema de Diseño

### Herencia del Tema Login
El módulo account hereda y extiende el sistema de diseño del módulo login:

- **Colores**: Misma paleta brick/blue
- **Tipografía**: Inter font family
- **Modo claro/oscuro**: Sistema consistente
- **Glassmorphism**: Efectos de vidrio similares

### Adaptaciones Específicas
```css
/* Navegación lateral para páginas de cuenta */
.account-nav {
  background: var(--bg-glass);
  backdrop-filter: blur(12px);
  border-radius: 12px;
}

/* Cards de información */
.account-card {
  background: var(--bg-glass);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Tablas de datos */
.account-table {
  background: var(--bg-primary);
  border-radius: 8px;
  overflow: hidden;
}
```

## 📄 Funcionalidades Principales

### 👤 Gestión de Perfil
**Características**:
- Edición de información personal (nombre, email, etc.)
- Carga de avatar/foto de perfil
- Configuración de preferencias de idioma
- Actualización de información de contacto

**Componentes CSS**:
```css
.profile-form { /* Formulario de perfil */ }
.avatar-upload { /* Área de carga de avatar */ }
.profile-field { /* Campos del perfil */ }
```

### 🔐 Configuración de Seguridad
**Características**:
- Cambio de contraseña
- Configuración de autenticación de dos factores (2FA)
- Gestión de preguntas de seguridad
- Revisión de actividad de la cuenta

**Componentes CSS**:
```css
.security-settings { /* Panel de configuración de seguridad */ }
.password-strength { /* Indicador de fortaleza de contraseña */ }
.two-factor-setup { /* Configuración de 2FA */ }
```

### 📱 Gestión de Sesiones
**Características**:
- Lista de sesiones activas
- Información de dispositivos y ubicaciones
- Capacidad de cerrar sesiones remotas
- Historial de inicios de sesión

**Componentes CSS**:
```css
.sessions-list { /* Lista de sesiones */ }
.session-item { /* Item individual de sesión */ }
.device-info { /* Información del dispositivo */ }
```

### 🔗 Aplicaciones Vinculadas
**Características**:
- Lista de aplicaciones autorizadas
- Revisión de permisos otorgados
- Revocación de acceso a aplicaciones
- Historial de consentimientos

**Componentes CSS**:
```css
.applications-grid { /* Grid de aplicaciones */ }
.app-card { /* Card de aplicación */ }
.permissions-list { /* Lista de permisos */ }
```

## 🎨 Estilos CSS (account.css)

### Estructura Base
```css
/* Importación de variables del tema login */
@import url('../../../login/resources/css/styles.css');

/* Layout principal de cuenta */
.account-layout {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

/* Navegación lateral */
.account-nav {
  background: var(--bg-glass);
  backdrop-filter: blur(12px);
  border-radius: 12px;
  padding: 1.5rem;
  height: fit-content;
  position: sticky;
  top: 2rem;
}
```

### Componentes Principales

#### Navegación
```css
.nav-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.nav-item {
  margin-bottom: 0.5rem;
}

.nav-link {
  display: flex;
  align-items: center;
  padding: 0.75rem 1rem;
  color: var(--text-secondary);
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.2s ease;
}

.nav-link:hover,
.nav-link.active {
  background: var(--bg-secondary);
  color: var(--text-primary);
}
```

#### Cards y Contenedores
```css
.content-card {
  background: var(--bg-glass);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 2rem;
  margin-bottom: 2rem;
}

.card-header {
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid var(--border-light);
}

.card-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0;
}
```

#### Formularios
```css
.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  font-weight: 500;
  color: var(--text-primary);
  margin-bottom: 0.5rem;
}

.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid var(--border-light);
  border-radius: 8px;
  background: var(--bg-primary);
  color: var(--text-primary);
  font-size: 1rem;
  transition: all 0.2s ease;
}

.form-input:focus {
  outline: none;
  border-color: var(--brick-600);
  box-shadow: 0 0 0 3px rgba(194, 65, 12, 0.1);
}
```

#### Tablas
```css
.data-table {
  width: 100%;
  border-collapse: collapse;
  background: var(--bg-primary);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.data-table th {
  background: var(--bg-secondary);
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: var(--text-primary);
}

.data-table td {
  padding: 1rem;
  border-bottom: 1px solid var(--border-light);
  color: var(--text-secondary);
}

.data-table tr:last-child td {
  border-bottom: none;
}
```

## 📱 Responsividad

### Layout Adaptativo
```css
@media (max-width: 1024px) {
  .account-layout {
    grid-template-columns: 1fr;
    padding: 1rem;
  }
  
  .account-nav {
    position: static;
    margin-bottom: 2rem;
  }
}

@media (max-width: 768px) {
  .account-nav {
    padding: 1rem;
  }
  
  .content-card {
    padding: 1.5rem;
  }
  
  .data-table {
    font-size: 0.875rem;
  }
  
  .data-table th,
  .data-table td {
    padding: 0.75rem 0.5rem;
  }
}
```

### Navegación Móvil
En dispositivos móviles, la navegación se convierte en un menú colapsible:
```css
@media (max-width: 768px) {
  .account-nav {
    order: -1;
  }
  
  .nav-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }
  
  .nav-item {
    margin-bottom: 0;
  }
  
  .nav-link {
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
  }
}
```

## 🌙 Soporte de Modo Oscuro

### Variables Específicas
```css
[data-theme="dark"] {
  /* Navegación en modo oscuro */
  --nav-bg: rgba(31, 41, 55, 0.95);
  --nav-border: rgba(75, 85, 99, 0.3);
  
  /* Cards en modo oscuro */
  --card-bg: rgba(31, 41, 55, 0.95);
  --card-border: rgba(75, 85, 99, 0.3);
  
  /* Tablas en modo oscuro */
  --table-header-bg: #374151;
  --table-border: #4b5563;
}
```

### Adaptaciones Visuales
- Bordes más sutiles en modo oscuro
- Shadows ajustados para mejor contraste
- Glassmorphism adaptado a fondos oscuros

## 🔧 Configuración (theme.properties)

```properties
parent=keycloak
import=common/keycloak

# Herencia del tema login
styles=../login/resources/css/styles.css,css/account.css

# Configuraciones específicas
locales=en,es,fr
```

## ✨ Características Avanzadas

### Indicadores de Estado
```css
.status-indicator {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 500;
}

.status-active {
  background: #dcfce7;
  color: #166534;
}

.status-inactive {
  background: #fee2e2;
  color: #991b1b;
}
```

### Animaciones y Transiciones
```css
.fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.slide-in {
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from { transform: translateX(-20px); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
```

## 🎯 Mejores Prácticas

### Consistencia Visual
- Mantener la coherencia con el tema login
- Usar las mismas variables CSS y patrones
- Respetar el sistema de espaciado establecido

### Accesibilidad
- Labels descriptivos en formularios
- Contraste adecuado en ambos modos de tema
- Navegación por teclado funcional
- ARIA labels para elementos interactivos

### Performance
- Reutilizar estilos del tema login
- Optimizar imágenes y assets
- Usar transiciones CSS en lugar de JavaScript

## 🔄 Integración con Login Theme

### Variables Compartidas
El módulo account importa automáticamente las variables del tema login:
```css
@import url('../../../login/resources/css/styles.css');
```

### Componentes Reutilizados
- Botones y formularios
- Sistema de colores y tipografía
- Utilidades de spacing y layout
- Manejo de temas claro/oscuro

## 📋 Checklist de Implementación

- [ ] Navegación lateral implementada
- [ ] Cards de contenido con glassmorphism
- [ ] Formularios consistentes con login
- [ ] Tablas de datos responsivas
- [ ] Estados activos/inactivos
- [ ] Modo oscuro funcionando
- [ ] Responsive design verificado
- [ ] Accesibilidad validada
- [ ] Performance optimizada

## 🐛 Resolución de Problemas Comunes

### Estilos no se heredan del login
- Verificar la importación en `theme.properties`
- Comprobar rutas relativas de CSS
- Reiniciar Keycloak después de cambios

### Layout roto en móvil
- Revisar media queries
- Verificar grid/flexbox fallbacks
- Comprobar overflow de contenido

### Modo oscuro inconsistente
- Verificar variables CSS en cascada
- Comprobar especificidad de selectores
- Validar JavaScript de toggle de tema

## 🔄 Historial de Cambios

### v1.0.0
- Layout de navegación lateral
- Cards con glassmorphism
- Sistema de tablas responsivo
- Integración completa con tema login
- Soporte completo para modo oscuro