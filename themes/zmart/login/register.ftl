<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        ¡Únete a ZMART!
        <p class="subtitle">Crea tu cuenta y disfruta de la mejor experiencia de compra</p>
    <#elseif section = "form">
        <form class="form" id="kc-register-form" action="${url.registrationAction}" method="post">
            <div class="row">
                <div class="label-wrap">
                    <label for="firstName">${msg("firstName")}</label>
                </div>
                <input type="text" id="firstName" class="input" name="firstName"
                       value="${(register.formData.firstName!'')}" placeholder="Ingresa tu nombre"
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
                       value="${(register.formData.lastName!'')}" placeholder="Ingresa tu apellido"
                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />
                <#if messagesPerField.existsError('lastName')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="row">
                <div class="label-wrap">
                    <label for="email">${msg("email")}</label>
                </div>
                <input type="email" id="email" class="input" name="email"
                       value="${(register.formData.email!'')}" placeholder="Ingresa tu email"
                       autocomplete="email"
                       aria-invalid="<#if messagesPerField.existsError('email')>true</#if>" />
                <#if messagesPerField.existsError('email')>
                    <span class="kcInputErrorMessageClass" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('email'))?no_esc}
                    </span>
                </#if>
            </div>

            <#if !realm.registrationEmailAsUsername>
                <div class="row">
                    <div class="label-wrap">
                        <label for="username">${msg("username")}</label>
                    </div>
                    <input type="text" id="username" class="input" name="username"
                           value="${(register.formData.username!'')}" placeholder="Ingresa tu usuario"
                           autocomplete="username"
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
                           placeholder="••••••••" autocomplete="new-password"
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
                           name="password-confirm" placeholder="••••••••" autocomplete="new-password"
                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                    <#if messagesPerField.existsError('password-confirm')>
                        <span class="kcInputErrorMessageClass" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if recaptchaRequired??>
                <div class="row">
                    <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                </div>
            </#if>

            <div class="actions">
                <button class="btn login" type="submit">${msg("doRegister")}</button>
                <a class="forgot" href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a>
            </div>

            <#if realm.password && social.providers??>
                <div class="divider">Or</div>
                
                <#list social.providers as p>
                    <a id="social-${p.alias}" class="btn google" href="${p.loginUrl}">
                        <#if p.providerId == "google">
                            <span class="google-icon" aria-hidden="true"></span>
                        <#else>
                            <i class="${p.iconClasses!}" aria-hidden="true"></i>
                        </#if>
                        <span>Register with ${p.displayName!}</span>
                    </a>
                </#list>
            </#if>
        </form>

    </#if>
</@layout.registrationLayout>