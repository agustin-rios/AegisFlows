<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section = "header">
        Actualizar contraseña
        <p class="subtitle">Es necesario actualizar tu contraseña para continuar</p>
    <#elseif section = "form">
        <form class="form" id="kc-passwd-update-form" action="${url.loginAction}" method="post">
            <div class="row">
                <div class="label-wrap">
                    <label for="password-new">${msg("passwordNew")}</label>
                </div>
                <input type="password" id="password-new" name="password-new" class="input"
                       placeholder="••••••••" autofocus autocomplete="new-password"
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
                <input type="password" id="password-confirm" name="password-confirm" class="input"
                       placeholder="••••••••" autocomplete="new-password"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                <#if messagesPerField.existsError('password-confirm')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="actions">
                <#if isAppInitiatedAction??>
                    <button class="btn login" type="submit">${msg("doSubmit")}</button>
                    <button class="btn" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
                <#else>
                    <button class="btn login" type="submit">${msg("doSubmit")}</button>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>