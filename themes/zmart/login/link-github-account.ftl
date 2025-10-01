<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("linkAccount", "GitHub")}
        <p class="subtitle">Conecta tu cuenta GitHub para continuar con el acceso federado.</p>
    <#elseif section = "form">
        <form class="form" action="${url.requiredActionUrl}" method="post">
            <div class="actions">
                <button type="submit" class="btn login">${msg("linkAccount", "GitHub")}</button>
                <a href="${url.loginUrl}" class="forgot">${msg("backToLogin")}</a>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
