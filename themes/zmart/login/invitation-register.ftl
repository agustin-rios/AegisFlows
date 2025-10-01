<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        ${msg("registerWithTitle", realm.displayName!'')}
    <#elseif section = "form">
        <form class="form" action="${url.registrationAction}" method="post">

            <div class="row">
                <div class="label-wrap">
                    <label for="firstName">${msg("firstName")}</label>
                </div>
                <input type="text" id="firstName" class="input" name="firstName"
                       value="${(register.formData.firstName!'')}"
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
                <input type="text" id="lastName" class="input" name="lastName"
                       value="${(register.formData.lastName!'')}"
                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />
                <#if messagesPerField.existsError('lastName')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <#if !realm.registrationEmailAsUsername>
                <div class="row">
                    <div class="label-wrap">
                        <label for="username">${msg("username")}</label>
                    </div>
                    <input type="text" id="username" class="input" name="username"
                           value="${(register.formData.username!'')}"
                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                    <#if messagesPerField.existsError('username')>
                        <span class="kcInputErrorMessageClass" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if passwordRequired??>
                <div class="row">
                    <div class="label-wrap">
                        <label for="password">${msg("password")}</label>
                    </div>
                    <input type="password" id="password" class="input" name="password"
                           autocomplete="new-password"
                           aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>" />
                    <#if messagesPerField.existsError('password')>
                        <span class="kcInputErrorMessageClass" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div class="row">
                    <div class="label-wrap">
                        <label for="password-confirm">${msg("passwordConfirm")}</label>
                    </div>
                    <input type="password" id="password-confirm" class="input"
                           name="password-confirm" autocomplete="new-password"
                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                    <#if messagesPerField.existsError('password-confirm')>
                        <span class="kcInputErrorMessageClass" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <div class="actions">
                <button class="btn login" type="submit">${msg("doRegister")}</button>
                <a class="forgot" href="${url.loginUrl}">${msg("backToLogin")}</a>
            </div>
        </form>


    </#if>
</@layout.registrationLayout>