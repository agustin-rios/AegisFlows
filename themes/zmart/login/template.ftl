<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta name="robots" content="noindex, nofollow">
  
  <#if properties.meta?has_content>
    <#list properties.meta?split(' ') as meta>
      <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
    </#list>
  </#if>
  
  <title>ZMART · ${msg("loginTitle",(realm.displayName!''))}</title>
  <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  
  <#if properties.stylesCommon?has_content>
    <#list properties.stylesCommon?split(' ') as style>
      <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
    </#list>
  </#if>
  <#if properties.styles?has_content>
    <#list properties.styles?split(' ') as style>
      <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
    </#list>
  </#if>
  <#if properties.scripts?has_content>
    <#list properties.scripts?split(' ') as script>
      <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
    </#list>
  </#if>
  <#if scripts??>
    <#list scripts as script>
      <script src="${script}" type="text/javascript"></script>
    </#list>
  </#if>
</head>

<body>
  <!-- Theme Toggle -->
  <div class="theme-toggle">
    <span class="theme-label" id="theme-label">Light</span>
    <div class="toggle-switch" id="theme-switch">
      <div class="toggle-slider">
        <span id="theme-icon">☀️</span>
      </div>
    </div>
  </div>

  <main class="layout" id="kc-login">
    <!-- Lado Izquierdo: formulario -->
    <section class="pane pane--left" id="kc-form-card">
      <div class="container" id="kc-content-wrapper">
        <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
          <#if displayRequiredFields>
            <div class="subtitle">
              <span class="required">*</span> ${msg("requiredFields")}
            </div>
            <h1 class="title" id="kc-page-title"><#nested "header"></h1>
          <#else>
            <h1 class="title" id="kc-page-title"><#nested "header"></h1>
          </#if>
        <#else>
          <#if displayRequiredFields>
            <div class="subtitle">
              <span class="required">*</span> ${msg("requiredFields")}
            </div>
            <#nested "show-username">
            <div id="kc-username" class="${properties.kcFormGroupClass!}">
              <label id="kc-attempted-username">${auth.attemptedUsername}</label>
              <a id="reset-login" href="${url.loginRestartFlowUrl}">
                <div class="kc-login-tooltip">
                  <i class="${properties.kcResetFlowIcon!}"></i>
                  <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                </div>
              </a>
            </div>
          <#else>
            <#nested "show-username">
            <div id="kc-username" class="${properties.kcFormGroupClass!}">
              <label id="kc-attempted-username">${auth.attemptedUsername}</label>
              <a id="reset-login" href="${url.loginRestartFlowUrl}">
                <div class="kc-login-tooltip">
                  <i class="${properties.kcResetFlowIcon!}"></i>
                  <span class="kc-tooltip-text">${msg("restartLoginTooltip")}</span>
                </div>
              </a>
            </div>
          </#if>
        </#if>

        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
          <div class="alert-${message.type}">
            <span>${kcSanitize(message.summary)?no_esc}</span>
          </div>
        </#if>

        <#nested "form">

        <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
          <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
              <input type="hidden" name="tryAnotherWay" value="on"/>
              <a href="#" id="try-another-way"
                 onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
            </div>
          </form>
        </#if>
      </div>
    </section>

    <!-- Lado Derecho: imagen + ZMART marca -->
    <section class="pane pane--right" aria-label="ZMART Hero" id="kc-info">
      <div class="hero" aria-hidden="true"></div>
      <div class="hero-card" role="img" aria-label="ZMART">
        <div class="hero-text">ZMART</div>
        <#if displayInfo>
          <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
            <#nested "info">
          </div>
        </#if>
      </div>
    </section>
  </main>

  <script>
    // Theme Management System
    class ThemeManager {
      constructor() {
        this.themeSwitch = document.getElementById('theme-switch');
        this.themeLabel = document.getElementById('theme-label');
        this.themeIcon = document.getElementById('theme-icon');
        this.currentTheme = this.getInitialTheme();
        
        this.init();
      }
      
      getInitialTheme() {
        // Prioridad: localStorage > preferencia del sistema > light
        const savedTheme = localStorage.getItem('zmart-theme');
        if (savedTheme) return savedTheme;
        
        return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
      }
      
      init() {
        this.applyTheme(this.currentTheme);
        this.themeSwitch.addEventListener('click', () => this.toggleTheme());
        
        // Listen for system theme changes
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
          if (!localStorage.getItem('zmart-theme')) {
            this.currentTheme = e.matches ? 'dark' : 'light';
            this.applyTheme(this.currentTheme);
          }
        });
      }
      
      toggleTheme() {
        this.currentTheme = this.currentTheme === 'light' ? 'dark' : 'light';
        this.applyTheme(this.currentTheme);
        localStorage.setItem('zmart-theme', this.currentTheme);
      }
      
      applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        
        if (theme === 'dark') {
          this.themeSwitch.classList.add('active');
          this.themeLabel.textContent = 'Dark';
          this.themeIcon.textContent = '🌙';
        } else {
          this.themeSwitch.classList.remove('active');
          this.themeLabel.textContent = 'Light';
          this.themeIcon.textContent = '☀️';
        }
      }
    }
    
    // Initialize theme manager when DOM is loaded
    document.addEventListener('DOMContentLoaded', () => {
      new ThemeManager();
    });
    
    // Enhanced form interactions
    document.addEventListener('DOMContentLoaded', () => {
      // Add focus effects to inputs
      const inputs = document.querySelectorAll('.input, .kcInputClass, input[type="text"], input[type="password"], input[type="email"]');
      inputs.forEach(input => {
        input.addEventListener('focus', function() {
          const parent = this.parentElement;
          if (parent) parent.classList.add('focused');
        });
        
        input.addEventListener('blur', function() {
          const parent = this.parentElement;
          if (parent) parent.classList.remove('focused');
        });
      });
      
      // Add loading state to login button
      const loginBtn = document.querySelector('.btn.login, .kcButtonPrimaryClass, #kc-login');
      if (loginBtn) {
        loginBtn.addEventListener('click', function(e) {
          if (this.classList.contains('loading')) return;
          
          this.classList.add('loading');
          const originalText = this.textContent || this.value;
          if (this.tagName === 'INPUT') {
            this.value = 'Signing in...';
          } else {
            this.textContent = 'Signing in...';
          }
          
          // Simulate loading (remove in production)
          setTimeout(() => {
            this.classList.remove('loading');
            if (this.tagName === 'INPUT') {
              this.value = originalText;
            } else {
              this.textContent = originalText;
            }
          }, 2000);
        });
      }
    });
  </script>
</body>
</html>
</#macro>