# Login Module - ZMart Theme

El módulo de login maneja todas las páginas relacionadas con autenticación y registro de usuarios en Keycloak.

## 📁 Estructura de Archivos

```text
login/
├── README.md                    # Este archivo
├── theme.properties            # Configuración del tema
├── template.ftl                # Plantilla base para todas las páginas
├── login.ftl                   # Página principal de inicio de sesión
├── register.ftl                # Página de registro de usuarios
├── error.ftl                   # Página de manejo de errores
├── login-reset-password.ftl    # Página de reset de contraseña
├── invitation-register.ftl     # Registro por invitación (simplificado)
├── link-google-account.ftl     # Enlace de cuenta Google (simplificado)
├── link-github-account.ftl     # Enlace de cuenta GitHub (simplificado)
└── resources/
    ├── css/
    │   └── styles.css          # Hoja de estilos principal
    └── img/
        └── background.png      # Imagen de fondo del hero
```

## 🎨 Sistema de Diseño

### Layout Principal
- **Diseño de dos columnas**: Hero section (izquierda) + Formulario (derecha)
- **Hero section**: 60% del ancho, imagen de fondo, overlay con gradiente
- **Formulario**: 40% del ancho, centrado, con glassmorphism

### Colores y Variables CSS
```css
:root {
  /* Colores principales */
  --brick-700: #c2410c;
  --brick-600: #dc2626;
  --brick-500: #ea580c;
  --blue-600: #2563eb;
  --blue-500: #3b82f6;
  
  /* Backgrounds */
  --bg-primary: #ffffff;
  --bg-secondary: #f8fafc;
  --bg-glass: rgba(255, 255, 255, 0.95);
  
  /* Texto */
  --text-primary: #1f2937;
  --text-secondary: #6b7280;
  --text-muted: #9ca3af;
}
```

### Modo Oscuro
```css
[data-theme="dark"] {
  --bg-primary: #1f2937;
  --bg-secondary: #111827;
  --bg-glass: rgba(31, 41, 55, 0.95);
  --text-primary: #f9fafb;
  --text-secondary: #d1d5db;
  --text-muted: #9ca3af;
}
```

## 📄 Plantillas (FTL Files)

### template.ftl
**Propósito**: Plantilla base que define la estructura HTML común para todas las páginas de login.

**Características**:
- Layout de dos columnas responsivo
- Modo claro/oscuro automático según `prefers-color-scheme`
- Hero section con imagen y overlay
- Contenedor de formulario con glassmorphism
- Carga de fuentes (Inter) desde Google Fonts
- Contenedor superior para mensajes de estado del servidor

**Secciones**:
- `header`: Título y subtítulo de la página
- `form`: Contenido del formulario
- `info`: Información adicional (opcional)

### login.ftl
**Propósito**: Página principal de inicio de sesión.

**Características**:
- Formulario de login con email/username y contraseña
- Checkbox "Recordarme"
- Enlaces a registro y reset de contraseña
- Integración con proveedores sociales (Google, GitHub)
- Manejo de errores y mensajes

**Campos**:
- Username/Email
- Password
- Remember me (opcional)

### register.ftl
**Propósito**: Página de registro de nuevos usuarios.

**Características**:
- Formulario de registro con validación
- Campos de nombre, email, username, contraseña
- Confirmación de contraseña
- Integración con proveedores sociales
- Términos y condiciones (opcional)

**Campos**:
- First Name
- Last Name
- Email
- Username (si está habilitado)
- Password
- Password Confirmation

### error.ftl
**Propósito**: Página de manejo de errores.

**Características**:
- Diseño consistente con el tema
- Iconografía apropiada para diferentes tipos de error
- Botones de acción (volver, reintentar)
- Mensajes de error localizados

### login-reset-password.ftl
**Propósito**: Página para solicitar reset de contraseña.

**Características**:
- Formulario simple con campo de email
- Instrucciones claras para el usuario
- Manejo de estados (enviado, error)
- Enlace de regreso al login

### invitation-register.ftl
**Propósito**: Registro por invitación administrativa (simplificado).

**Características**:
- Formulario básico de registro
- Campos esenciales únicamente
- Diseño limpio y directo
- Sin flujos complejos multi-paso

### link-*-account.ftl
**Propósito**: Páginas para enlazar cuentas sociales.

**Características**:
- Reutilizan el layout estándar del formulario
- Mensaje corto con instrucciones
- Botón principal y enlace de regreso al login

## 🎯 Estilos CSS (styles.css)

### Estructura Principal
- Variables CSS definen la paleta brick/blue y transparencias para glassmorphism.
- `.layout` (+ `#kc-page`) crea un grid de dos columnas que se apila en mobile.
- `.pane--right` carga la imagen `resources/img/background.png` como hero.
- `.container` y `#kc-content-wrapper` limitan el ancho del formulario.

### Componentes Principales
- `.form`, `.row`, `.label-wrap`, `.input`: estilos base reutilizados por todas las plantillas.
- `.btn.login` y `.kcButtonPrimaryClass`: botones de acciones primarias.
- `.status-messages` y variantes `.alert-*`: área para mensajes globales del servidor.
- `.btn` y `.kcButtonClass`: botones principales y secundarios

#### Estados Interactivos
- **Hover**: Transiciones suaves en botones e inputs
- **Focus**: Rings de enfoque accesibles
- **Active**: Estados presionados
- **Disabled**: Estados deshabilitados

#### Responsive Design
- `@media (max-width: 980px)`: el grid pasa a una sola columna y el hero se coloca debajo del formulario.
- `@media (max-width: 640px)`: se ajustan los paddings para conservar legibilidad en móviles.

## 🌙 Sistema de Temas

El modo claro/oscuro se resuelve únicamente con CSS utilizando `prefers-color-scheme` y la propiedad `color-scheme` en `body`. No se requiere JavaScript.

## 📱 Responsividad

### Breakpoints
- **Desktop**: > 1024px (layout completo de dos columnas)
- **Tablet**: 768px - 1024px (layout adaptado)
- **Mobile**: < 768px (columna única, hero oculto)

### Adaptaciones Móviles
- Hero section se oculta completamente
- Formulario ocupa todo el ancho
- Espaciado reducido
- Tipografía ajustada
- Botones de ancho completo

## 🔧 Configuración (theme.properties)

```properties
parent=keycloak
import=common/keycloak

# Estilos específicos del tema
styles=css/styles.css

# Configuraciones adicionales
kcHtmlClass=login-pf
```

## 🎨 Personalización

### Cambiar Colores Principales
Modifica las variables CSS en `:root`:
```css
:root {
  --brick-700: #tu-color-primario;
  --blue-600: #tu-color-secundario;
}
```

### Cambiar Imagen de Fondo
Reemplaza `resources/img/background.png` con tu imagen personalizada.

### Modificar Layout
Ajusta las proporciones del grid en `.layout`:
```css
.layout {
  grid-template-columns: 2fr 1fr; /* Más espacio para hero */
}
```

## ✅ Mejores Prácticas

1. **Consistencia**: Mantén los patrones de diseño establecidos
2. **Accesibilidad**: Usa labels apropiados y ARIA attributes
3. **Performance**: Optimiza imágenes y CSS
4. **Testing**: Prueba en ambos modos de tema
5. **Responsive**: Verifica en diferentes tamaños de pantalla

## 🐛 Resolución de Problemas

### Tema no se aplica
- Verifica que el tema esté seleccionado en la configuración del realm
- Asegúrate de que los archivos estén en la ubicación correcta
- Reinicia Keycloak después de cambios

### Estilos no se cargan
- Verifica la ruta en `theme.properties`
- Comprueba permisos de archivos
- Revisa la consola del navegador para errores

### Modo oscuro no funciona
- Verifica que JavaScript esté habilitado
- Comprueba la implementación del toggle
- Revisa las variables CSS del modo oscuro

## 📋 Lista de Verificación para Nuevas Páginas

- [ ] Usa `template.ftl` como base
- [ ] Define sección `header` apropiada
- [ ] Implementa sección `form` con validation
- [ ] Agrega manejo de errores
- [ ] Verifica responsividad
- [ ] Prueba modo claro y oscuro
- [ ] Validar accesibilidad
- [ ] Documentar cambios

## 🔄 Historial de Cambios

### v1.0.0
- Implementación inicial del diseño moderno
- Sistema de temas claro/oscuro
- Layout de dos columnas con glassmorphism
- Simplificación de plantillas complejas
- Mejoras en responsividad y accesibilidad
