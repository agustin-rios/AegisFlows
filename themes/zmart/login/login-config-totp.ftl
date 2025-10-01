<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp','userLabel'); section>
    <#if section = "header">
        Configurar autenticación
        <p class="subtitle">Configura tu aplicación de autenticación de dos factores</p>
    <#elseif section = "form">
        <ol id="kc-totp-settings">
            <li>
                <p>${msg("loginTotpStep1")}</p>
            </li>
            <li>
                <p>${msg("loginTotpStep2")}</p>
                <img id="kc-totp-secret-qr-code" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="Figure: Barcode"><br/>
                <span id="kc-totp-secret-key">${totp.totpSecretEncoded}</span>
            </li>
            <li>
                <p>${msg("loginTotpStep3")}</p>
                <p>${msg("loginTotpStep3DeviceName")}</p>
            </li>
        </ol>

        <form action="${url.loginAction}" class="form" id="kc-totp-settings-form" method="post">
            <div class="row">
                <div class="label-wrap">
                    <label for="totp">${msg("authenticatorCode")}</label>
                </div>
                <input type="text" id="totp" name="totp" class="input" placeholder="000000"
                       autocomplete="off" autofocus
                       aria-invalid="<#if messagesPerField.existsError('totp','userLabel')>true</#if>"/>
                <#if messagesPerField.existsError('totp')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('totp'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="row">
                <div class="label-wrap">
                    <label for="userLabel">${msg("loginTotpDeviceName")}</label>
                </div>
                <input type="text" id="userLabel" name="userLabel" class="input"
                       placeholder="${msg('loginTotpDeviceName')}" autocomplete="off"
                       aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>"/>
                <#if messagesPerField.existsError('userLabel')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('userLabel'))?no_esc}
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