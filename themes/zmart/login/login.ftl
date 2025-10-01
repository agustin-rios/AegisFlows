<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ¡Bienvenido de vuelta!
        <p class="subtitle">Ingresa tus credenciales para acceder a tu cuenta</p>
    <#elseif section = "form">
        <#if realm.password>
            <form class="form" id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                <#if !usernameHidden??>
                    <div class="row">
                        <div class="label-wrap">
                            <label for="username">
                                <#if !realm.loginWithEmailAllowed>
                                    ${msg("username")}
                                <#elseif !realm.registrationEmailAsUsername>
                                    ${msg("usernameOrEmail")}
                                <#else>
                                    ${msg("email")}
                                </#if>
                            </label>
                        </div>
                        <input tabindex="1" id="username" class="input" name="username"
                               value="${(login.username!'')}" type="text" 
                               placeholder="<#if !realm.loginWithEmailAllowed>Ingresa tu usuario<#elseif !realm.registrationEmailAsUsername>Ingresa tu usuario o email<#else>Ingresa tu email</#if>"
                               autofocus autocomplete="off"
                               aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                        
                        <#if messagesPerField.existsError('username','password')>
                            <span class="kcInputErrorMessageClass" aria-live="polite">
                                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                            </span>
                        </#if>
                    </div>
                </#if>

                <div class="row">
                    <div class="label-wrap">
                        <label for="password">${msg("password")}</label>
                        <#if realm.resetPasswordAllowed>
                            <a class="forgot" tabindex="5" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                        </#if>
                    </div>
                    <input tabindex="2" id="password" class="input" name="password"
                           type="password" placeholder="••••••••" autocomplete="current-password"
                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                    
                    <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                        <span class="kcInputErrorMessageClass" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div class="actions">
                    <#if realm.rememberMe && !usernameHidden??>
                        <label class="remember">
                            <#if login.rememberMe??>
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked />
                            <#else>
                                <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" />
                            </#if>
                            <span>${msg("rememberMe")}</span>
                        </label>
                    </#if>
                    
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <button tabindex="4" class="btn login" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
                </div>

                <#if realm.password && social.providers??>
                    <div class="divider">Or</div>
                    
                    <#list social.providers as p>
                        <a id="social-${p.alias}" class="btn google" href="${p.loginUrl}">
                            <#if p.providerId == "google">
                                <span class="google-icon" aria-hidden="true"></span>
                            <#else>
                                <i class="${p.iconClasses!}" aria-hidden="true"></i>
                            </#if>
                            <span>Sign in with ${p.displayName!}</span>
                        </a>
                    </#list>
                </#if>
            </form>
        </#if>
    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>

<script>
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const passwordIcon = document.getElementById('password-icon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        passwordIcon.classList.remove('fa-eye');
        passwordIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        passwordIcon.classList.remove('fa-eye-slash');
        passwordIcon.classList.add('fa-eye');
    }
}

// Auto-focus on username field
document.addEventListener('DOMContentLoaded', function() {
    const usernameField = document.getElementById('username');
    if (usernameField) {
        usernameField.focus();
    }
});

// Social login animation
document.addEventListener('DOMContentLoaded', function() {
    const socialLinks = document.querySelectorAll('.social-link');
    socialLinks.forEach(link => {
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        link.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
});
</script>