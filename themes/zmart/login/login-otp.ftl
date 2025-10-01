<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section = "header">
        Verificación requerida
        <p class="subtitle">Ingresa el código de tu aplicación de autenticación</p>
    <#elseif section = "form">
        <form class="form" id="kc-otp-login-form" action="${url.loginAction}" method="post">
            <div class="row">
                <div class="label-wrap">
                    <label for="otp">${msg("loginOtpOneTime")}</label>
                </div>
                <input id="otp" name="otp" type="text" class="input" placeholder="000000"
                       autofocus autocomplete="off"
                       aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" />
                <#if messagesPerField.existsError('totp')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('totp'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="actions">
                <button class="btn login" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
                <#if client?? && client.baseUrl?has_content>
                    <a class="forgot" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>