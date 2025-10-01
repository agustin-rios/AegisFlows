<#import "template.ftl" as layout>
<@layout.registrationLayout displayRequiredFields=false showAnotherWayIfPresent=true displayInfo=true; section>
    <#if section = "header">
        🔗 Link Your GitHub Account (Optional)
    <#elseif section = "form">
        <div class="social-linking-step">
            <div class="step-header">
                <div class="step-indicator">
                    <div class="step-number">2</div>
                    <div class="step-info">
                        <h3>Connect GitHub Account</h3>
                        <p>Optional - Enhance your developer profile</p>
                    </div>
                </div>
            </div>

            <div class="social-provider-card github-card">
                <div class="provider-header">
                    <img src="${url.resourcesPath}/img/github-logo.svg" alt="GitHub" class="provider-logo">
                    <div class="provider-info">
                        <h4>GitHub</h4>
                        <p>Connect your developer profile and repositories</p>
                    </div>
                </div>

                <div class="connection-status">
                    <#if githubLinked?? && githubLinked>
                        <div class="status-connected">
                            <i class="fas fa-check-circle"></i>
                            <span>GitHub account connected successfully!</span>
                            <div class="connected-info">
                                <strong>${githubUsername!""}</strong>
                            </div>
                        </div>
                        
                        <form id="continue-form" action="${url.requiredActionUrl}" method="post">
                            <input type="hidden" name="action" value="complete"/>
                            <button type="submit" class="btn btn-primary btn-large">
                                Continue to Profile Setup <i class="fas fa-arrow-right"></i>
                            </button>
                        </form>
                    <#else>
                        <div class="status-optional">
                            <i class="fas fa-code-branch"></i>
                            <span>Connect GitHub for developer features</span>
                        </div>

                        <div class="benefits-list">
                            <h5>Why connect GitHub?</h5>
                            <ul>
                                <li>✅ Professional developer validation</li>
                                <li>✅ Access to developer-exclusive features</li>
                                <li>✅ Portfolio and project showcase</li>
                                <li>✅ Community networking opportunities</li>
                                <li>✅ Enhanced profile credibility</li>
                            </ul>
                        </div>

                        <div class="action-buttons">
                            <form action="${url.requiredActionUrl}" method="post" style="margin-bottom: 1rem;">
                                <input type="hidden" name="action" value="link-github"/>
                                <button type="submit" class="btn btn-primary btn-large github-connect-btn">
                                    <i class="fab fa-github"></i>
                                    Connect GitHub Account
                                </button>
                            </form>

                            <form action="${url.requiredActionUrl}" method="post">
                                <input type="hidden" name="action" value="skip"/>
                                <button type="submit" class="btn btn-secondary btn-large">
                                    Skip for Now
                                </button>
                            </form>
                        </div>
                    </#if>
                </div>
            </div>

            <div class="progress-info">
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 66%;"></div>
                </div>
                <div class="progress-text">
                    Step 2 of 3: Link GitHub Account (Optional)
                </div>
            </div>

            <div class="completed-connections">
                <h5>✅ Completed Steps</h5>
                <div class="connection-list">
                    <div class="connection-item completed">
                        <i class="fab fa-google"></i>
                        <span>Google Account Connected</span>
                        <i class="fas fa-check-circle status-icon"></i>
                    </div>
                </div>
            </div>

            <div class="next-steps">
                <h5>What's next?</h5>
                <div class="step-preview">
                    <div class="step-item">
                        <span class="step-badge">3</span>
                        <span>Complete your profile information</span>
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

            .github-card {
                border-color: #333;
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
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

            .status-optional {
                text-align: center;
                padding: 1.5rem;
                background: #f0f9ff;
                border: 2px solid #bae6fd;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }

            .status-optional i {
                color: var(--zmart-info);
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }

            .status-optional span {
                display: block;
                color: var(--zmart-info);
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

            .github-connect-btn {
                background: #333 !important;
                border-color: #333 !important;
            }

            .github-connect-btn:hover {
                background: #1f2937 !important;
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

            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
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

            .completed-connections {
                background: #f0fdf4;
                padding: 1.5rem;
                border-radius: 12px;
                border: 1px solid #bbf7d0;
                margin-bottom: 1.5rem;
            }

            .completed-connections h5 {
                margin: 0 0 1rem 0;
                color: var(--zmart-success);
            }

            .connection-list {
                display: flex;
                flex-direction: column;
                gap: 0.75rem;
            }

            .connection-item {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                padding: 0.75rem;
                background: white;
                border-radius: 8px;
                font-size: 0.9rem;
            }

            .connection-item i:first-child {
                font-size: 1.2rem;
                width: 20px;
            }

            .connection-item.completed {
                border: 1px solid #bbf7d0;
            }

            .connection-item.completed i:first-child {
                color: #ea4335;
            }

            .status-icon {
                margin-left: auto;
                color: var(--zmart-success);
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
            <h4>GitHub Connection is Optional</h4>
            <p>While connecting GitHub enhances your profile, you can always add it later from your account settings.</p>
        </div>
    </#if>
</@layout.registrationLayout>