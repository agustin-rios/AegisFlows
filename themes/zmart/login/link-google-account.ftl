<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("linkAccount", "Google")}
        <p class="subtitle">Conecta tu cuenta Google para completar el inicio de sesión.</p>
    <#elseif section = "form">
        <form class="form" action="${url.requiredActionUrl}" method="post">
            <div class="actions">
                <button type="submit" class="btn login">${msg("linkAccount", "Google")}</button>
                <a href="${url.loginUrl}" class="forgot">${msg("backToLogin")}</a>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
