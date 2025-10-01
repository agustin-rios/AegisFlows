<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        Actualizando información
        <p class="subtitle">Es necesario actualizar tu información para continuar</p>
    <#elseif section = "form">
        <form class="form" id="kc-update-user-form" action="${url.loginAction}" method="post">
            <#if user.editUsernameAllowed>
                <div class="row">
                    <div class="label-wrap">
                        <label for="username">${msg("username")}</label>
                    </div>
                    <input type="text" id="username" name="username" class="input"
                           value="${(user.username!'')}" placeholder="Ingresa tu usuario"
                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                    <#if messagesPerField.existsError('username')>
                        <span class="kcInputErrorMessageClass" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <div class="row">
                <div class="label-wrap">
                    <label for="email">${msg("email")}</label>
                </div>
                <input type="email" id="email" name="email" class="input"
                       value="${(user.email!'')}" placeholder="Ingresa tu email"
                       aria-invalid="<#if messagesPerField.existsError('email')>true</#if>" />
                <#if messagesPerField.existsError('email')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('email'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="row">
                <div class="label-wrap">
                    <label for="firstName">${msg("firstName")}</label>
                </div>
                <input type="text" id="firstName" name="firstName" class="input"
                       value="${(user.firstName!'')}" placeholder="Ingresa tu nombre"
                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>" />
                <#if messagesPerField.existsError('firstName')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('firstName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="row">
                <div class="label-wrap">
                    <label for="lastName">${msg("lastName")}</label>
                </div>
                <input type="text" id="lastName" name="lastName" class="input"
                       value="${(user.lastName!'')}" placeholder="Ingresa tu apellido"
                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />
                <#if messagesPerField.existsError('lastName')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="actions">
                <#if isAppInitiatedAction??>
                    <button class="btn login" type="submit" name="login" id="kc-login">${msg("doSubmit")}</button>
                    <button class="btn" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
                <#else>
                    <button class="btn login" type="submit" name="login" id="kc-login">${msg("doSubmit")}</button>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>