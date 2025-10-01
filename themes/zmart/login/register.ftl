<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        🎉 Join ZMart - Complete Your Registration
    <#elseif section = "form">
        
        <!-- Registration Progress Indicator -->
        <div class="registration-progress">
            <div class="progress-step active">
                <div class="step-icon">📝</div>
                <span>Registration</span>
            </div>
            <div class="progress-step pending">
                <div class="step-icon">🔗</div>
                <span>Link Google</span>
            </div>
            <div class="progress-step pending">
                <div class="step-icon">🔗</div>
                <span>Link GitHub</span>
            </div>
        </div>

        <div class="registration-intro">
            <h2>Welcome to ZMart!</h2>
            <p>Create your account and we'll guide you through connecting your social accounts for enhanced security and features.</p>
        </div>
        <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <label for="firstName" class="${properties.kcLabelClass!}">${msg("firstName")}</label>
                <input type="text" id="firstName" class="${properties.kcInputClass!}" name="firstName"
                       value="${(register.formData.firstName!'')}"
                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                />

                <#if messagesPerField.existsError('firstName')>
                    <span id="input-error-firstname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('firstName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="lastName" class="${properties.kcLabelClass!}">${msg("lastName")}</label>
                <input type="text" id="lastName" class="${properties.kcInputClass!}" name="lastName"
                       value="${(register.formData.lastName!'')}"
                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                />

                <#if messagesPerField.existsError('lastName')>
                    <span id="input-error-lastname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
                <input type="text" id="email" class="${properties.kcInputClass!}" name="email"
                       value="${(register.formData.email!'')}" autocomplete="email"
                       aria-invalid="<#if messagesPerField.existsError('email')>true</#if>"
                />

                <#if messagesPerField.existsError('email')>
                    <span id="input-error-email" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.getFirstError('email'))?no_esc}
                    </span>
                </#if>
            </div>

            <#if !realm.registrationEmailAsUsername>
                <div class="${properties.kcFormGroupClass!}">
                    <label for="username" class="${properties.kcLabelClass!}">${msg("username")}</label>
                    <input type="text" id="username" class="${properties.kcInputClass!}" name="username"
                           value="${(register.formData.username!'')}" autocomplete="username"
                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                    />

                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if passwordRequired??>
                <div class="${properties.kcFormGroupClass!}">
                    <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" class="${properties.kcInputClass!}" name="password"
                               autocomplete="new-password"
                               aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                        />
                        <button type="button" class="password-toggle" onclick="togglePassword('password')">
                            <i class="fas fa-eye" id="password-icon"></i>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('password')>
                        <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div class="${properties.kcFormGroupClass!}">
                    <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>
                    <div class="password-wrapper">
                        <input type="password" id="password-confirm" class="${properties.kcInputClass!}"
                               name="password-confirm" autocomplete="new-password"
                               aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                        />
                        <button type="button" class="password-toggle" onclick="togglePassword('password-confirm')">
                            <i class="fas fa-eye" id="password-confirm-icon"></i>
                        </button>
                    </div>

                    <#if messagesPerField.existsError('password-confirm')>
                        <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                            ${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if recaptchaRequired??>
                <div class="form-group">
                    <div class="${properties.kcInputWrapperClass!}">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                    </div>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <span><a href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
                    </div>
                </div>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doRegister")}"/>
                </div>
            </div>
        </form>

        <div class="next-steps-info">
            <h4>🚀 What happens after registration?</h4>
            <div class="step-list">
                <div class="step-item">
                    <span class="step-number">1</span>
                    <div class="step-content">
                        <strong>Email Verification</strong>
                        <p>Check your email and verify your account</p>
                    </div>
                </div>
                <div class="step-item">
                    <span class="step-number">2</span>
                    <div class="step-content">
                        <strong>Link Google Account</strong>
                        <p>Required for secure authentication</p>
                    </div>
                </div>
                <div class="step-item">
                    <span class="step-number">3</span>
                    <div class="step-content">
                        <strong>Link GitHub Account</strong>
                        <p>Optional - Enhance your developer profile</p>
                    </div>
                </div>
            </div>
        </div>

        <#if realm.password && social.providers??>
            <div id="kc-social-providers" class="${properties.kcFormSocialAccountSectionClass!}">
                <hr class="social-divider"/>
                <h4>🚀 Quick Registration with Social Accounts</h4>
                <p class="social-description">Register instantly and we'll guide you through linking additional accounts</p>

                <ul class="${properties.kcFormSocialAccountListClass!} <#if social.providers?size gt 3>${properties.kcFormSocialAccountListGridClass!}</#if>">
                    <#list social.providers as p>
                        <li class="${properties.kcFormSocialAccountListLinkClass!}">
                            <a id="social-${p.alias}" class="${properties.kcFormSocialAccountLinkClass!} social-link-${p.providerId}" 
                               href="${p.loginUrl}">
                                <i class="${p.iconClasses!}" aria-hidden="true"></i>
                                <span class="social-provider-name">Register with ${p.displayName!}</span>
                            </a>
                        </li>
                    </#list>
                </ul>
            </div>
        </#if>

        <style>
            .registration-progress {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 2rem;
                padding: 1rem;
                background: #f8fafc;
                border-radius: 12px;
                border: 1px solid #e5e7eb;
            }

            .progress-step {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 0 1rem;
                position: relative;
                flex: 1;
                max-width: 120px;
            }

            .progress-step:not(:last-child)::after {
                content: '';
                position: absolute;
                top: 25px;
                right: -50%;
                width: 100%;
                height: 2px;
                background: #e5e7eb;
                z-index: 1;
            }

            .progress-step.active::after {
                background: var(--zmart-primary);
            }

            .step-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: #e5e7eb;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                margin-bottom: 0.5rem;
                position: relative;
                z-index: 2;
                transition: all 0.3s ease;
            }

            .progress-step.active .step-icon {
                background: var(--zmart-gradient);
                color: white;
            }

            .progress-step span {
                font-size: 0.8rem;
                font-weight: 600;
                color: #6b7280;
                text-align: center;
            }

            .progress-step.active span {
                color: var(--zmart-primary);
            }

            .registration-intro {
                text-align: center;
                margin-bottom: 2rem;
                padding: 1.5rem;
                background: var(--zmart-gradient);
                color: white;
                border-radius: 12px;
            }

            .registration-intro h2 {
                margin: 0 0 0.5rem 0;
                font-size: 1.5rem;
            }

            .registration-intro p {
                margin: 0;
                opacity: 0.9;
            }

            .next-steps-info {
                background: #f0f9ff;
                border: 1px solid #bae6fd;
                border-radius: 12px;
                padding: 1.5rem;
                margin: 2rem 0;
            }

            .next-steps-info h4 {
                margin: 0 0 1rem 0;
                color: var(--zmart-primary);
            }

            .step-list {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }

            .step-item {
                display: flex;
                align-items: flex-start;
                gap: 1rem;
            }

            .step-number {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                background: var(--zmart-primary);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
                font-weight: 600;
                flex-shrink: 0;
            }

            .step-content strong {
                display: block;
                color: var(--zmart-dark);
                margin-bottom: 0.25rem;
            }

            .step-content p {
                margin: 0;
                font-size: 0.9rem;
                color: var(--zmart-gray);
            }

            .social-description {
                text-align: center;
                color: var(--zmart-gray);
                font-size: 0.9rem;
                margin-bottom: 1rem;
            }

            @media (max-width: 768px) {
                .registration-progress {
                    flex-direction: column;
                    gap: 1rem;
                }
                
                .progress-step::after {
                    display: none;
                }
                
                .step-list {
                    gap: 0.75rem;
                }
                
                .step-item {
                    flex-direction: column;
                    text-align: center;
                    gap: 0.5rem;
                }
            }
        </style>
    </#if>
</@layout.registrationLayout>

<script>
function togglePassword(fieldId) {
    const passwordInput = document.getElementById(fieldId);
    const passwordIcon = document.getElementById(fieldId + '-icon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        passwordIcon.classList.remove('fa-eye');
        passwordIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        passwordIcon.classList.remove('fa-eye-slash');
        passwordIcon.classList.add('fa-eye');
    }
}

// Password strength indicator
document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('password');
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            updatePasswordStrengthIndicator(strength);
        });
    }
});

function calculatePasswordStrength(password) {
    let score = 0;
    if (password.length >= 8) score++;
    if (password.match(/[a-z]/)) score++;
    if (password.match(/[A-Z]/)) score++;
    if (password.match(/[0-9]/)) score++;
    if (password.match(/[^a-zA-Z0-9]/)) score++;
    return score;
}

function updatePasswordStrengthIndicator(strength) {
    // This would update a password strength indicator if present
    const indicators = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];
    const colors = ['#ef4444', '#f59e0b', '#f59e0b', '#10b981', '#10b981'];
    
    // Implementation would depend on having a strength indicator element
    console.log('Password strength:', indicators[strength] || 'Very Weak');
}

// Form validation
document.getElementById('kc-register-form').addEventListener('submit', function(e) {
    const password = document.getElementById('password');
    const passwordConfirm = document.getElementById('password-confirm');
    
    if (password && passwordConfirm && password.value !== passwordConfirm.value) {
        e.preventDefault();
        alert('Passwords do not match');
        return false;
    }
});
</script>