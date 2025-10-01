<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        Recuperar contraseña
        <p class="subtitle">Te enviaremos un enlace para restablecer tu contraseña</p>
    <#elseif section = "form">
        <form class="form" id="kc-reset-password-form" action="${url.loginAction}" method="post">
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
                <input type="text" id="username" name="username" class="input" autofocus 
                       value="${(auth.attemptedUsername!'')}"
                       placeholder="<#if !realm.loginWithEmailAllowed>Ingresa tu usuario<#elseif !realm.registrationEmailAsUsername>Ingresa tu usuario o email<#else>Ingresa tu email</#if>"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                <#if messagesPerField.existsError('username')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}
                    </span>
                </#if>
            </div>
            
            <div class="actions">
                <button class="btn login" type="submit">${msg("doSubmit")}</button>
                <a class="forgot" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            </div>
        </form>
    <#elseif section = "info">
        <div class="alert-info">
            ${msg("emailInstruction")}
        </div>
    </#if>
</@layout.registrationLayout>