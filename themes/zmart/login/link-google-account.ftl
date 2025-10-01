<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("linkAccount", "Google")}
    <#elseif section = "form">
        <div class="link-provider-container">
            <div class="provider-info">
                <i class="fab fa-google" style="color: #ea4335; font-size: 3rem;"></i>
                <h2>Link Google Account</h2>
                <p>Connect your Google account for easier sign-in and enhanced security.</p>
            </div>

            <form action="${url.requiredActionUrl}" method="post">
                <button type="submit" class="btn btn-primary">
                    <i class="fab fa-google"></i>
                    ${msg("linkAccount", "Google")}
                </button>
            </form>

            <div class="actions">
                <a href="${url.loginUrl}" class="forgot">${msg("backToLogin")}</a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>