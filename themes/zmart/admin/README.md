# Admin Module - ZMart Theme

El módulo de admin personaliza la consola de administración de Keycloak con el sistema de diseño ZMart.

## 📁 Estructura de Archivos

```text
admin/
├── README.md                   # Este archivo
├── theme.properties           # Configuración del tema
└── resources/
    └── css/
        └── admin.css          # Hoja de estilos principal
```

## 🎯 Propósito

Este módulo proporciona una interfaz administrativa cohesiva que incluye:

- **Dashboard administrativo**: Panel principal con métricas y accesos rápidos
- **Gestión de usuarios**: Creación, edición y administración de usuarios
- **Configuración del realm**: Ajustes de seguridad y configuración
- **Gestión de clientes**: Administración de aplicaciones cliente
- **Monitoreo del sistema**: Logs, eventos y métricas de rendimiento

## 🎨 Sistema de Diseño

### Adaptación del Tema Base
El módulo admin adapta el sistema de diseño ZMart para interfaces administrativas:

```css
/* Paleta de colores administrativa */
:root {
  --admin-primary: #c2410c;      /* Brick orange */
  --admin-secondary: #2563eb;    /* Blue */
  --admin-success: #059669;      /* Green */
  --admin-warning: #d97706;      /* Orange */
  --admin-danger: #dc2626;       /* Red */
  --admin-info: #0891b2;         /* Cyan */
}
```

### Layout Administrativo
```css
/* Layout principal de administración */
.admin-layout {
  display: grid;
  grid-template-areas: 
    "sidebar header"
    "sidebar main";
  grid-template-columns: 280px 1fr;
  grid-template-rows: 60px 1fr;
  min-height: 100vh;
}

/* Sidebar de navegación */
.admin-sidebar {
  grid-area: sidebar;
  background: var(--bg-glass);
  backdrop-filter: blur(12px);
  border-right: 1px solid rgba(255, 255, 255, 0.2);
}

/* Header administrativo */
.admin-header {
  grid-area: header;
  background: var(--bg-primary);
  border-bottom: 1px solid var(--border-light);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 2rem;
}

/* Área de contenido principal */
.admin-main {
  grid-area: main;
  padding: 2rem;
  background: var(--bg-secondary);
  overflow-y: auto;
}
```

## 📊 Componentes Administrativos

### Dashboard y Métricas
```css
/* Grid de métricas */
.metrics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

/* Cards de métricas */
.metric-card {
  background: var(--bg-glass);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 1.5rem;
  text-align: center;
}

.metric-value {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--admin-primary);
  margin-bottom: 0.5rem;
}

.metric-label {
  color: var(--text-secondary);
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
```

### Navegación Administrativa
```css
/* Navegación lateral */
.admin-nav {
  padding: 1.5rem 0;
}

.nav-section {
  margin-bottom: 2rem;
}

.nav-section-title {
  padding: 0 1.5rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--text-muted);
}

.nav-menu {
  list-style: none;
  padding: 0;
  margin: 0;
}

.nav-item {
  margin-bottom: 0.25rem;
}

.nav-link {
  display: flex;
  align-items: center;
  padding: 0.75rem 1.5rem;
  color: var(--text-secondary);
  text-decoration: none;
  border-radius: 0 24px 24px 0;
  margin-right: 1rem;
  transition: all 0.2s ease;
}

.nav-link:hover,
.nav-link.active {
  background: linear-gradient(90deg, var(--admin-primary), var(--admin-secondary));
  color: white;
  transform: translateX(4px);
}

.nav-icon {
  margin-right: 0.75rem;
  width: 18px;
  height: 18px;
}
```

### Tablas de Datos Administrativas
```css
/* Tabla administrativa avanzada */
.admin-table {
  width: 100%;
  background: var(--bg-primary);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.admin-table thead {
  background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
}

.admin-table th {
  padding: 1rem 1.5rem;
  color: white;
  font-weight: 600;
  text-align: left;
  font-size: 0.875rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.admin-table td {
  padding: 1rem 1.5rem;
  border-bottom: 1px solid var(--border-light);
  color: var(--text-secondary);
}

.admin-table tbody tr:hover {
  background: var(--bg-secondary);
}

.admin-table tbody tr:last-child td {
  border-bottom: none;
}
```

### Formularios Administrativos
```css
/* Formularios de configuración */
.admin-form {
  background: var(--bg-glass);
  backdrop-filter: blur(8px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  padding: 2rem;
}

.form-section {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--border-light);
}

.form-section:last-child {
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: 0;
}

.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 1rem;
}

.section-description {
  color: var(--text-secondary);
  margin-bottom: 1.5rem;
  line-height: 1.6;
}
```

### Botones de Acción Administrativa
```css
/* Botones primarios */
.btn-admin-primary {
  background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-admin-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(194, 65, 12, 0.3);
}

/* Botones de acción específicos */
.btn-success {
  background: var(--admin-success);
  color: white;
}

.btn-warning {
  background: var(--admin-warning);
  color: white;
}

.btn-danger {
  background: var(--admin-danger);
  color: white;
}

/* Botones de tamaño pequeño */
.btn-sm {
  padding: 0.5rem 1rem;
  font-size: 0.75rem;
}

/* Botones de ancho completo */
.btn-block {
  width: 100%;
  display: block;
}
```

## 📱 Responsividad Administrativa

### Layout Adaptativo
```css
@media (max-width: 1024px) {
  .admin-layout {
    grid-template-areas: 
      "header"
      "main";
    grid-template-columns: 1fr;
    grid-template-rows: 60px 1fr;
  }
  
  .admin-sidebar {
    position: fixed;
    top: 60px;
    left: -280px;
    height: calc(100vh - 60px);
    z-index: 1000;
    transition: left 0.3s ease;
  }
  
  .admin-sidebar.open {
    left: 0;
  }
  
  .sidebar-overlay {
    position: fixed;
    top: 60px;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 999;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
  }
  
  .sidebar-overlay.active {
    opacity: 1;
    visibility: visible;
  }
}

@media (max-width: 768px) {
  .admin-main {
    padding: 1rem;
  }
  
  .metrics-grid {
    grid-template-columns: 1fr;
  }
  
  .admin-table {
    font-size: 0.875rem;
  }
  
  .admin-table th,
  .admin-table td {
    padding: 0.75rem 1rem;
  }
}
```

### Navegación Móvil
```css
/* Toggle del menú móvil */
.mobile-menu-toggle {
  display: none;
  background: none;
  border: none;
  color: var(--text-primary);
  font-size: 1.25rem;
  cursor: pointer;
  padding: 0.5rem;
}

@media (max-width: 1024px) {
  .mobile-menu-toggle {
    display: block;
  }
}

/* Navegación en móvil */
@media (max-width: 768px) {
  .nav-link {
    margin-right: 0;
    border-radius: 8px;
    margin: 0 1rem 0.25rem;
  }
  
  .nav-link:hover,
  .nav-link.active {
    transform: none;
  }
}
```

## 🌙 Modo Oscuro Administrativo

### Variables Específicas
```css
[data-theme="dark"] {
  /* Colores administrativos en modo oscuro */
  --admin-bg-primary: #1f2937;
  --admin-bg-secondary: #111827;
  --admin-bg-glass: rgba(31, 41, 55, 0.95);
  --admin-border: #374151;
  --admin-text-primary: #f9fafb;
  --admin-text-secondary: #d1d5db;
  
  /* Sidebar en modo oscuro */
  --sidebar-bg: rgba(17, 24, 39, 0.95);
  --sidebar-border: rgba(55, 65, 81, 0.5);
  
  /* Header en modo oscuro */
  --header-bg: #1f2937;
  --header-border: #374151;
}
```

### Adaptaciones Visuales
```css
[data-theme="dark"] .admin-table {
  background: var(--admin-bg-primary);
}

[data-theme="dark"] .admin-table thead {
  background: linear-gradient(135deg, #9a3412, #1d4ed8);
}

[data-theme="dark"] .admin-table tbody tr:hover {
  background: var(--admin-bg-secondary);
}

[data-theme="dark"] .metric-card {
  background: var(--admin-bg-glass);
  border-color: var(--admin-border);
}
```

## 🔧 Configuración (theme.properties)

```properties
parent=keycloak.v2
import=common/keycloak

# Herencia de estilos base
styles=../login/resources/css/styles.css,css/admin.css

# Scripts adicionales para funcionalidad admin
scripts=js/admin.js

# Configuraciones específicas
locales=en,es,fr,de

# Configuración de navegación
kcHtmlClass=admin-v2
```

## ⚡ JavaScript Administrativo

### Funcionalidades Interactivas
```javascript
// Toggle de navegación móvil
function toggleSidebar() {
  const sidebar = document.querySelector('.admin-sidebar');
  const overlay = document.querySelector('.sidebar-overlay');
  
  sidebar.classList.toggle('open');
  overlay.classList.toggle('active');
}

// Auto-refresh de métricas
function updateMetrics() {
  fetch('/admin/realms/{realm}/metrics')
    .then(response => response.json())
    .then(data => {
      updateMetricCards(data);
    });
}

// Confirmación de acciones críticas
function confirmAction(message, callback) {
  const modal = createConfirmModal(message);
  modal.onConfirm = callback;
  modal.show();
}

// Filtrado de tablas
function initTableFilters() {
  const searchInputs = document.querySelectorAll('.table-search');
  searchInputs.forEach(input => {
    input.addEventListener('input', filterTable);
  });
}
```

## 🎯 Características Avanzadas

### Indicadores de Estado del Sistema
```css
.system-status {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.status-healthy { background: var(--admin-success); }
.status-warning { background: var(--admin-warning); }
.status-critical { background: var(--admin-danger); }

.status-text {
  font-size: 0.875rem;
  font-weight: 500;
}
```

### Badges y Etiquetas
```css
.badge {
  display: inline-flex;
  align-items: center;
  padding: 0.25rem 0.75rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.badge-primary { 
  background: rgba(194, 65, 12, 0.1); 
  color: var(--admin-primary); 
}

.badge-success { 
  background: rgba(5, 150, 105, 0.1); 
  color: var(--admin-success); 
}

.badge-warning { 
  background: rgba(217, 119, 6, 0.1); 
  color: var(--admin-warning); 
}

.badge-danger { 
  background: rgba(220, 38, 38, 0.1); 
  color: var(--admin-danger); 
}
```

### Tooltips y Ayuda Contextual
```css
.tooltip {
  position: relative;
  display: inline-block;
}

.tooltip-content {
  position: absolute;
  bottom: 125%;
  left: 50%;
  transform: translateX(-50%);
  background: var(--admin-bg-primary);
  color: var(--admin-text-primary);
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition: all 0.2s ease;
  z-index: 1000;
}

.tooltip:hover .tooltip-content {
  opacity: 1;
  visibility: visible;
}
```

## 🛠️ Personalización Administrativa

### Temas de Color
```css
/* Tema azul corporativo */
.theme-corporate {
  --admin-primary: #1e40af;
  --admin-secondary: #3b82f6;
}

/* Tema verde ecológico */
.theme-eco {
  --admin-primary: #059669;
  --admin-secondary: #10b981;
}

/* Tema morado creativo */
.theme-creative {
  --admin-primary: #7c3aed;
  --admin-secondary: #8b5cf6;
}
```

### Densidad de Información
```css
/* Vista compacta */
.density-compact .admin-table th,
.density-compact .admin-table td {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}

.density-compact .metric-card {
  padding: 1rem;
}

/* Vista cómoda */
.density-comfortable .admin-table th,
.density-comfortable .admin-table td {
  padding: 1.5rem 2rem;
}

.density-comfortable .metric-card {
  padding: 2rem;
}
```

## 📋 Checklist de Implementación

- [ ] Layout administrativo responsive
- [ ] Navegación lateral funcional
- [ ] Dashboard con métricas
- [ ] Tablas de datos avanzadas
- [ ] Formularios de configuración
- [ ] Sistema de notificaciones
- [ ] Modo oscuro completo
- [ ] Accesibilidad administrativa
- [ ] Optimización de performance
- [ ] Testing en múltiples dispositivos

## 🔄 Historial de Cambios

### v1.0.0
- Layout administrativo completo
- Sistema de navegación avanzado
- Dashboard con métricas en tiempo real
- Tablas administrativas mejoradas
- Formularios de configuración optimizados
- Soporte completo para modo oscuro
- Responsividad administrativa