<#import "template.ftl" as layout>
<@layout.registrationLayout displayRequiredFields=false showAnotherWayIfPresent=true displayInfo=true; section>
    <#if section = "header">
        🔗 Link Your Google Account
    <#elseif section = "form">
        <div class="social-linking-step">
            <div class="step-header">
                <div class="step-indicator">
                    <div class="step-number">1</div>
                    <div class="step-info">
                        <h3>Connect Google Account</h3>
                        <p>Required for secure authentication</p>
                    </div>
                </div>
            </div>

            <div class="social-provider-card google-card">
                <div class="provider-header">
                    <img src="${url.resourcesPath}/img/google-logo.svg" alt="Google" class="provider-logo">
                    <div class="provider-info">
                        <h4>Google</h4>
                        <p>Sign in with your Google account for enhanced security</p>
                    </div>
                </div>

                <div class="connection-status">
                    <#if googleLinked?? && googleLinked>
                        <div class="status-connected">
                            <i class="fas fa-check-circle"></i>
                            <span>Google account connected successfully!</span>
                            <div class="connected-info">
                                <strong>${googleEmail!""}</strong>
                            </div>
                        </div>
                        
                        <form id="continue-form" action="${url.requiredActionUrl}" method="post">
                            <input type="hidden" name="action" value="complete"/>
                            <button type="submit" class="btn btn-primary btn-large">
                                Continue to Next Step <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    <#else>
                        <div class="status-pending">
                            <i class="fas fa-link"></i>
                            <span>Connect your Google account to continue</span>
                        </div>

                        <div class="benefits-list">
                            <h5>Why connect Google?</h5>
                            <ul>
                                <li>✅ Secure passwordless authentication</li>
                                <li>✅ Auto-fill profile information</li>
                                <li>✅ Easy sign-in for future visits</li>
                                <li>✅ Enhanced account security</li>
                            </ul>
                        </div>

                        <form action="${url.requiredActionUrl}" method="post">
                            <input type="hidden" name="action" value="link-google"/>
                            <button type="submit" class="btn btn-primary btn-large google-connect-btn">
                                <i class="fab fa-google"></i>
                                Connect Google Account
                            </button>
                        </form>
                    </#if>
                </div>
            </div>

            <div class="progress-info">
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 33%;"></div>
                </div>
                <div class="progress-text">
                    Step 1 of 3: Link Google Account
                </div>
            </div>

            <div class="next-steps">
                <h5>What's next?</h5>
                <div class="step-preview">
                    <div class="step-item">
                        <span class="step-badge">2</span>
                        <span>Link GitHub Account (Optional)</span>
                    </div>
                    <div class="step-item">
                        <span class="step-badge">3</span>
                        <span>Complete Your Profile</span>
                    </div>
                </div>
            </div>
        </div>

        <style>
            .social-linking-step {
                max-width: 500px;
                margin: 0 auto;
            }

            .step-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .step-indicator {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .step-number {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background: var(--zmart-gradient);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                font-weight: 700;
            }

            .step-info h3 {
                margin: 0;
                color: var(--zmart-primary);
                font-size: 1.5rem;
            }

            .step-info p {
                margin: 0.25rem 0 0 0;
                color: var(--zmart-gray);
            }

            .social-provider-card {
                background: white;
                border: 2px solid #e5e7eb;
                border-radius: 16px;
                padding: 2rem;
                margin-bottom: 2rem;
                transition: all 0.3s ease;
            }

            .google-card {
                border-color: #ea4335;
                background: linear-gradient(135deg, #ffffff 0%, #fef7f7 100%);
            }

            .provider-header {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 1.5rem;
            }

            .provider-logo {
                width: 48px;
                height: 48px;
            }

            .provider-info h4 {
                margin: 0;
                color: var(--zmart-dark);
                font-size: 1.2rem;
            }

            .provider-info p {
                margin: 0.25rem 0 0 0;
                color: var(--zmart-gray);
                font-size: 0.9rem;
            }

            .status-connected {
                text-align: center;
                padding: 1.5rem;
                background: #f0fdf4;
                border: 2px solid #bbf7d0;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }

            .status-connected i {
                color: var(--zmart-success);
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }

            .status-connected span {
                display: block;
                color: var(--zmart-success);
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .connected-info {
                font-size: 0.9rem;
                color: var(--zmart-gray);
            }

            .status-pending {
                text-align: center;
                padding: 1.5rem;
                background: #fffbeb;
                border: 2px solid #fed7aa;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }

            .status-pending i {
                color: var(--zmart-warning);
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }

            .status-pending span {
                display: block;
                color: var(--zmart-warning);
                font-weight: 600;
            }

            .benefits-list {
                background: #f8fafc;
                padding: 1.5rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }

            .benefits-list h5 {
                margin: 0 0 1rem 0;
                color: var(--zmart-dark);
            }

            .benefits-list ul {
                margin: 0;
                padding-left: 0;
                list-style: none;
            }

            .benefits-list li {
                margin-bottom: 0.5rem;
                color: var(--zmart-gray);
                font-size: 0.9rem;
            }

            .google-connect-btn {
                background: #ea4335 !important;
                border-color: #ea4335 !important;
            }

            .google-connect-btn:hover {
                background: #d33b2c !important;
                transform: translateY(-2px);
            }

            .btn-large {
                width: 100%;
                padding: 1rem 2rem;
                font-size: 1.1rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 0.5rem;
            }

            .progress-info {
                text-align: center;
                margin-bottom: 2rem;
            }

            .progress-bar {
                width: 100%;
                height: 6px;
                background: #e5e7eb;
                border-radius: 3px;
                overflow: hidden;
                margin-bottom: 0.5rem;
            }

            .progress-fill {
                height: 100%;
                background: var(--zmart-gradient);
                transition: width 0.3s ease;
            }

            .progress-text {
                font-size: 0.9rem;
                color: var(--zmart-gray);
                font-weight: 600;
            }

            .next-steps {
                background: #f8fafc;
                padding: 1.5rem;
                border-radius: 12px;
                border: 1px solid #e5e7eb;
            }

            .next-steps h5 {
                margin: 0 0 1rem 0;
                color: var(--zmart-dark);
            }

            .step-preview {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
            }

            .step-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                color: var(--zmart-gray);
                font-size: 0.9rem;
            }

            .step-badge {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                background: #e5e7eb;
                color: var(--zmart-gray);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
                font-weight: 600;
            }
        </style>
    <#elseif section = "info">
        <div class="help-info">
            <h4>Need Help?</h4>
            <p>If you're having trouble connecting your Google account, please contact our support team.</p>
            <a href="mailto:support@zmart.com" class="support-link">support@zmart.com</a>
        </div>
    </#if>
</@layout.registrationLayout>