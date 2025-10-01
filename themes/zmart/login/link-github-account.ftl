<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("linkAccount", "GitHub")}
    <#elseif section = "form">
        <div class="link-provider-container">
            <div class="provider-info">
                <i class="fab fa-github" style="color: #333; font-size: 3rem;"></i>
                <h2>Link GitHub Account</h2>
                <p>Connect your GitHub account for developer features and enhanced authentication.</p>
            </div>

            <form action="${url.requiredActionUrl}" method="post">
                <button type="submit" class="btn btn-primary">
                    <i class="fab fa-github"></i>
                    ${msg("linkAccount", "GitHub")}
                </button>
            </form>

            <div class="actions">
                <a href="${url.loginUrl}" class="forgot">${msg("backToLogin")}</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>