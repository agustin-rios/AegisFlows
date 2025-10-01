<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        Verificación de email
        <p class="subtitle">Hemos enviado un código de verificación a tu email</p>
    <#elseif section = "form">
        <p id="instruction1" class="instruction">
            ${msg("emailVerifyInstruction1",user.email)}
        </p>
        <p id="instruction2" class="instruction">
            ${msg("emailVerifyInstruction2")}
            <br/>
            <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}
        </p>
        <p id="instruction3" class="instruction">
            <a href="${url.loginEmailVerificationUrl}">${msg("emailVerifyInstruction3")}</a>
        </p>
    </#if>
</@layout.registrationLayout>