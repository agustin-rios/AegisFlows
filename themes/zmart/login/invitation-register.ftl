<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm'); section>
    <#if section = "header">
        Complete Your ZMart Registration
    <#elseif section = "form">
        <div class="invitation-flow">
            <!-- Progress Indicator -->
            <div class="progress-indicator">
                <div class="step ${(step == 'google' || step == 'github' || step == 'profile')?then('active', 'pending')}" data-step="1">
                    <div class="step-icon">🔗</div>
                    <div class="step-label">Link Google</div>
                </div>
                <div class="step ${(step == 'github' || step == 'profile')?then('active', 'pending')}" data-step="2">
                    <div class="step-icon">🔗</div>
                    <div class="step-label">Link GitHub</div>
                </div>
                <div class="step ${(step == 'profile')?then('active', 'pending')}" data-step="3">
                    <div class="step-icon">✏️</div>
                    <div class="step-label">Complete Profile</div>
                </div>
            </div>

            <!-- Welcome Message -->
            <div class="welcome-section">
                <h2>🎉 Welcome to ZMart!</h2>
                <p>You've been invited to join our platform. Let's get your account set up in just a few steps.</p>
                <div class="invitation-info">
                    <strong>Invited Email:</strong> ${user.email!'your.email@example.com'}
                </div>
            </div>

            <#-- Step 1: Google Account Linking -->
            <#if step == 'google' || !step??>
                <div class="step-section active" id="google-step">
                    <div class="step-header">
                        <h3>Step 1: Connect Your Google Account</h3>
                        <p>Link your Google account for secure authentication and profile setup.</p>
                    </div>

                    <div class="social-connection-card">
                        <div class="provider-info">
                            <img src="${url.resourcesPath}/img/google-logo.svg" alt="Google" class="provider-logo">
                            <div class="provider-details">
                                <h4>Google Account</h4>
                                <p>Secure sign-in with your Google credentials</p>
                            </div>
                        </div>
                        
                        <#if social.providers??>
                            <#list social.providers as p>
                                <#if p.providerId == 'google'>
                                    <a href="${p.loginUrl}&prompt=consent" class="btn btn-primary connect-btn">
                                        <i class="fab fa-google"></i> Connect Google Account
                                    </a>
                                </#if>
                            </#list>
                        <#else>
                            <button class="btn btn-primary connect-btn" onclick="connectGoogle()">
                                <i class="fab fa-google"></i> Connect Google Account
                            </button>
                        </#if>
                    </div>

                    <div class="why-connect">
                        <h4>Why connect Google?</h4>
                        <ul>
                            <li>✅ Secure authentication without passwords</li>
                            <li>✅ Auto-fill profile information</li>
                            <li>✅ Easy sign-in for future visits</li>
                            <li>✅ Enhanced account security</li>
                        </ul>
                    </div>
                </div>
            </#if>

            <#-- Step 2: GitHub Account Linking -->
            <#if step == 'github'>
                <div class="step-section active" id="github-step">
                    <div class="step-header">
                        <h3>Step 2: Connect Your GitHub Account</h3>
                        <p>Link your GitHub account for developer features and social validation.</p>
                    </div>

                    <div class="social-connection-card">
                        <div class="provider-info">
                            <img src="${url.resourcesPath}/img/github-logo.svg" alt="GitHub" class="provider-logo">
                            <div class="provider-details">
                                <h4>GitHub Account</h4>
                                <p>Connect your developer profile and repositories</p>
                            </div>
                        </div>
                        
                        <#if social.providers??>
                            <#list social.providers as p>
                                <#if p.providerId == 'github'>
                                    <a href="${p.loginUrl}&prompt=consent" class="btn btn-primary connect-btn">
                                        <i class="fab fa-github"></i> Connect GitHub Account
                                    </a>
                                </#if>
                            </#list>
                        <#else>
                            <button class="btn btn-primary connect-btn" onclick="connectGitHub()">
                                <i class="fab fa-github"></i> Connect GitHub Account
                            </button>
                        </#if>
                    </div>

                    <div class="why-connect">
                        <h4>Why connect GitHub?</h4>
                        <ul>
                            <li>✅ Professional developer validation</li>
                            <li>✅ Access to developer-exclusive features</li>
                            <li>✅ Portfolio and project showcase</li>
                            <li>✅ Community networking opportunities</li>
                        </ul>
                    </div>

                    <div class="step-actions">
                        <button class="btn btn-secondary" onclick="skipGitHub()">Skip for Now</button>
                    </div>
                </div>
            </#if>

            <#-- Step 3: Complete Profile -->
            <#if step == 'profile'>
                <div class="step-section active" id="profile-step">
                    <div class="step-header">
                        <h3>Step 3: Complete Your Profile</h3>
                        <p>Fill in your details to finish setting up your ZMart account.</p>
                    </div>

                    <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">
                        <div class="form-row">
                            <div class="${properties.kcFormGroupClass!}">
                                <label for="firstName" class="${properties.kcLabelClass!}">First Name *</label>
                                <input type="text" id="firstName" class="${properties.kcInputClass!}" name="firstName"
                                       value="${(register.formData.firstName!'')}" required
                                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>"
                                />
                                <#if messagesPerField.existsError('firstName')>
                                    <span id="input-error-firstname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                        ${kcSanitize(messagesPerField.getFirstError('firstName'))?no_esc}
                                    </span>
                                </#if>
                            </div>

                            <div class="${properties.kcFormGroupClass!}">
                                <label for="lastName" class="${properties.kcLabelClass!}">Last Name *</label>
                                <input type="text" id="lastName" class="${properties.kcInputClass!}" name="lastName"
                                       value="${(register.formData.lastName!'')}" required
                                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>"
                                />
                                <#if messagesPerField.existsError('lastName')>
                                    <span id="input-error-lastname" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                        ${kcSanitize(messagesPerField.getFirstError('lastName'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </div>

                        <div class="${properties.kcFormGroupClass!}">
                            <label for="email" class="${properties.kcLabelClass!}">Email Address</label>
                            <input type="email" id="email" class="${properties.kcInputClass!}" name="email"
                                   value="${(register.formData.email!'')}" readonly
                                   style="background-color: #f3f4f6; color: #6b7280;"
                            />
                            <small class="help-text">Email address provided by your invitation</small>
                        </div>

                        <#if !realm.registrationEmailAsUsername>
                            <div class="${properties.kcFormGroupClass!}">
                                <label for="username" class="${properties.kcLabelClass!}">Username *</label>
                                <input type="text" id="username" class="${properties.kcInputClass!}" name="username"
                                       value="${(register.formData.username!'')}" required
                                       placeholder="Choose a unique username"
                                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                                />
                                <small class="help-text">This will be your unique identifier on ZMart</small>
                                <#if messagesPerField.existsError('username')>
                                    <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                        ${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </#if>

                        <!-- Password fields only if not using social login -->
                        <#if passwordRequired?? && !socialConnected??>
                            <div class="form-row">
                                <div class="${properties.kcFormGroupClass!}">
                                    <label for="password" class="${properties.kcLabelClass!}">Password *</label>
                                    <div class="password-wrapper">
                                        <input type="password" id="password" class="${properties.kcInputClass!}" name="password"
                                               required autocomplete="new-password"
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
                                    <label for="password-confirm" class="${properties.kcLabelClass!}">Confirm Password *</label>
                                    <div class="password-wrapper">
                                        <input type="password" id="password-confirm" class="${properties.kcInputClass!}"
                                               name="password-confirm" required autocomplete="new-password"
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
                            </div>
                        </#if>

                        <!-- Additional Profile Fields -->
                        <div class="form-row">
                            <div class="${properties.kcFormGroupClass!}">
                                <label for="phone" class="${properties.kcLabelClass!}">Phone Number</label>
                                <input type="tel" id="phone" class="${properties.kcInputClass!}" name="phone"
                                       value="${(register.formData.phone!'')}"
                                       placeholder="+1 (555) 123-4567"
                                />
                            </div>

                            <div class="${properties.kcFormGroupClass!}">
                                <label for="company" class="${properties.kcLabelClass!}">Company</label>
                                <input type="text" id="company" class="${properties.kcInputClass!}" name="company"
                                       value="${(register.formData.company!'')}"
                                       placeholder="Your company name"
                                />
                            </div>
                        </div>

                        <!-- Terms and Conditions -->
                        <div class="${properties.kcFormGroupClass!}">
                            <div class="checkbox-wrapper">
                                <input type="checkbox" id="terms" name="terms" required>
                                <label for="terms">
                                    I agree to the <a href="${properties.termsUrl}" target="_blank">Terms of Service</a> 
                                    and <a href="${properties.privacyUrl}" target="_blank">Privacy Policy</a>
                                </label>
                            </div>
                        </div>

                        <div class="${properties.kcFormGroupClass!}">
                            <div class="checkbox-wrapper">
                                <input type="checkbox" id="newsletter" name="newsletter">
                                <label for="newsletter">
                                    Send me updates about new features and promotions
                                </label>
                            </div>
                        </div>

                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                            <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" 
                                   type="submit" value="Complete Registration"/>
                        </div>
                    </form>
                </div>
            </#if>

            <!-- Connected Accounts Summary -->
            <#if connectedAccounts??>
                <div class="connected-accounts">
                    <h4>🔗 Connected Accounts</h4>
                    <div class="account-list">
                        <#if googleConnected??>
                            <div class="connected-account google">
                                <i class="fab fa-google"></i>
                                <span>Google: ${googleEmail!'Connected'}</span>
                                <span class="status">✅</span>
                            </div>
                        </#if>
                        <#if githubConnected??>
                            <div class="connected-account github">
                                <i class="fab fa-github"></i>
                                <span>GitHub: ${githubUsername!'Connected'}</span>
                                <span class="status">✅</span>
                            </div>
                        </#if>
                    </div>
                </div>
            </#if>
        </div>

        <style>
            /* Invitation Flow Styles */
            .invitation-flow {
                max-width: 600px;
                margin: 0 auto;
            }

            .progress-indicator {
                display: flex;
                justify-content: center;
                margin-bottom: 2rem;
                position: relative;
            }

            .progress-indicator::before {
                content: '';
                position: absolute;
                top: 25px;
                left: 20%;
                right: 20%;
                height: 2px;
                background: #e5e7eb;
                z-index: 1;
            }

            .step {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 0 1rem;
                position: relative;
                z-index: 2;
            }

            .step-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: #f3f4f6;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                margin-bottom: 0.5rem;
                border: 3px solid #e5e7eb;
                transition: all 0.3s ease;
            }

            .step.active .step-icon {
                background: var(--zmart-gradient);
                color: white;
                border-color: var(--zmart-primary);
            }

            .step-label {
                font-size: 0.875rem;
                font-weight: 600;
                color: #6b7280;
                text-align: center;
            }

            .step.active .step-label {
                color: var(--zmart-primary);
            }

            .welcome-section {
                text-align: center;
                margin-bottom: 2rem;
                padding: 1.5rem;
                background: var(--zmart-gradient);
                color: white;
                border-radius: 12px;
            }

            .invitation-info {
                background: rgba(255, 255, 255, 0.2);
                padding: 0.75rem;
                border-radius: 8px;
                margin-top: 1rem;
            }

            .step-section {
                display: none;
                background: white;
                border-radius: 12px;
                padding: 2rem;
                box-shadow: var(--zmart-shadow);
                margin-bottom: 1.5rem;
            }

            .step-section.active {
                display: block;
            }

            .step-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .step-header h3 {
                color: var(--zmart-primary);
                margin: 0 0 0.5rem 0;
            }

            .social-connection-card {
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                transition: all 0.3s ease;
            }

            .social-connection-card:hover {
                border-color: var(--zmart-primary);
                box-shadow: var(--zmart-shadow);
            }

            .provider-info {
                display: flex;
                align-items: center;
                margin-bottom: 1rem;
            }

            .provider-logo {
                width: 48px;
                height: 48px;
                margin-right: 1rem;
            }

            .provider-details h4 {
                margin: 0 0 0.25rem 0;
                color: var(--zmart-dark);
            }

            .provider-details p {
                margin: 0;
                color: var(--zmart-gray);
                font-size: 0.875rem;
            }

            .connect-btn {
                width: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
                font-size: 1rem;
                font-weight: 600;
            }

            .why-connect {
                background: #f8fafc;
                padding: 1.5rem;
                border-radius: 8px;
                margin-bottom: 1rem;
            }

            .why-connect h4 {
                margin: 0 0 1rem 0;
                color: var(--zmart-dark);
            }

            .why-connect ul {
                margin: 0;
                padding-left: 0;
                list-style: none;
            }

            .why-connect li {
                margin-bottom: 0.5rem;
                color: var(--zmart-gray);
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1rem;
            }

            .checkbox-wrapper {
                display: flex;
                align-items: flex-start;
                gap: 0.5rem;
            }

            .checkbox-wrapper input[type="checkbox"] {
                margin-top: 0.25rem;
            }

            .connected-accounts {
                background: #f0fdf4;
                border: 1px solid #bbf7d0;
                border-radius: 12px;
                padding: 1.5rem;
                margin-top: 2rem;
            }

            .connected-accounts h4 {
                margin: 0 0 1rem 0;
                color: var(--zmart-success);
            }

            .connected-account {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.75rem;
                background: white;
                border-radius: 8px;
                margin-bottom: 0.5rem;
            }

            .connected-account:last-child {
                margin-bottom: 0;
            }

            .connected-account i {
                font-size: 1.2rem;
                width: 20px;
            }

            .connected-account.google i {
                color: #ea4335;
            }

            .connected-account.github i {
                color: #333;
            }

            .status {
                margin-left: auto;
                font-size: 1.1rem;
            }

            .step-actions {
                text-align: center;
                margin-top: 1.5rem;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }
                
                .progress-indicator {
                    flex-direction: column;
                    gap: 1rem;
                }
                
                .progress-indicator::before {
                    display: none;
                }
            }
        </style>

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

            function skipGitHub() {
                // Redirect to profile completion step
                window.location.href = window.location.href + '&step=profile';
            }

            // Auto-generate username from email
            document.addEventListener('DOMContentLoaded', function() {
                const emailField = document.getElementById('email');
                const usernameField = document.getElementById('username');
                
                if (emailField && usernameField && !usernameField.value) {
                    const email = emailField.value;
                    if (email) {
                        const username = email.split('@')[0].replace(/[^a-zA-Z0-9]/g, '');
                        usernameField.value = username;
                    }
                }
            });
        </script>
    </#if>
</@layout.registrationLayout>