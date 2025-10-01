<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        Oops! Algo salió mal
        <p class="subtitle">Ha ocurrido un error inesperado</p>
    <#elseif section = "form">
        <div class="form">
            <div class="alert-error">
                <span>${kcSanitize(message.summary)?no_esc}</span>
            </div>
            
            <div class="actions">
                <#if skipLink??>
                <#else>
                    <#if client?? && client.baseUrl?has_content>
                        <a class="btn login" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
                    <#else>
                        <a class="btn login" href="${url.loginUrl}">Volver al inicio de sesión</a>
                    </#if>
                </#if>
                <#if client?? && client.baseUrl?has_content>
                    <a class="forgot" href="${url.loginUrl}">Intentar de nuevo</a>
                </#if>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>