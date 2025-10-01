<#ftl output_format="HTML">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZMart - You're Invited! Complete Your Registration</title>
    <style>
        /* Import ZMart email styles */
        <#include "*/css/email.css">
    </style>
</head>
<body>
    <div class="email-container">
        <!-- Header -->
        <div class="email-header">
            <h1 class="logo">ZMart</h1>
            <p class="tagline">Your Ultimate E-commerce Experience</p>
        </div>

        <!-- Main Content -->
        <div class="email-body">
            <h1>🎉 You're Invited to Join ZMart!</h1>
            
            <p class="lead">Hello there!</p>
            
            <p>An administrator has invited you to join the <strong>ZMart E-commerce Platform</strong>. We're excited to welcome you to our growing community of customers and partners!</p>

            <div class="alert alert-info">
                <strong>📧 Invitation Details:</strong><br>
                Email: <strong>${user.email}</strong><br>
                Invited by: <strong>ZMart Administrator</strong><br>
                Date: <strong>${.now?string("MMMM dd, yyyy")}</strong>
            </div>

            <h2>🚀 Complete Your Registration</h2>
            <p>To activate your account and start exploring ZMart, please click the button below to complete your registration:</p>

            <div class="btn-container">
                <a href="${link}" class="btn">Complete Registration Now</a>
            </div>

            <div class="alert alert-warning">
                <strong>⏰ Time Sensitive:</strong> This invitation link will expire in <strong>7 days</strong>. Please complete your registration as soon as possible.
            </div>

            <h2>📋 Your Registration Journey</h2>
            <p>After clicking the registration link, you'll go through a simple process designed for security and convenience:</p>
            
            <div class="account-details">
                <table>
                    <tr>
                        <th style="text-align: center; width: 60px;">Step</th>
                        <th style="width: 200px;">Action</th>
                        <th>What This Means</th>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>1</strong></td>
                        <td><strong>📧 Verify Email</strong></td>
                        <td>Confirm this email address belongs to you</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>2</strong></td>
                        <td><strong>🔗 Link Google Account</strong></td>
                        <td><span style="color: #dc2626; font-weight: 600;">Required</span> - Connect your Google account for secure sign-in</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>3</strong></td>
                        <td><strong>🔗 Link GitHub Account</strong></td>
                        <td><span style="color: #059669; font-weight: 600;">Optional</span> - Connect for developer features and social validation</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>4</strong></td>
                        <td><strong>✅ Complete Profile</strong></td>
                        <td>Fill in your personal details and preferences</td>
                    </tr>
                </table>
            </div>

            <h2>🔐 Why Social Account Linking?</h2>
            <div class="benefits-grid">
                <div class="benefit-item">
                    <h4>🛡️ Enhanced Security</h4>
                    <p>Multi-factor authentication and reduced password fatigue</p>
                </div>
                <div class="benefit-item">
                    <h4>⚡ Quick Sign-In</h4>
                    <p>Use any of your linked accounts to sign in seamlessly</p>
                </div>
                <div class="benefit-item">
                    <h4>🤝 Social Validation</h4>
                    <p>Build trust with other users through verified social profiles</p>
                </div>
                <div class="benefit-item">
                    <h4>🚀 Developer Features</h4>
                    <p>Access exclusive features if you're a developer (GitHub required)</p>
                </div>
            </div>

            <div class="security-alert">
                <div class="icon">🔒</div>
                <h3>Your Privacy is Protected</h3>
                <p>We only access basic profile information needed for your ZMart account. You maintain full control over your data and can unlink accounts at any time from your account settings.</p>
            </div>

            <h2>💡 What You'll Get Access To</h2>
            <ul>
                <li><strong>🛒 Shop thousands of products</strong> - Browse our extensive catalog</li>
                <li><strong>❤️ Create wishlists</strong> - Save your favorite items for later</li>
                <li><strong>🎁 Exclusive member deals</strong> - Get access to member-only discounts</li>
                <li><strong>⚡ Fast checkout</strong> - Secure and streamlined purchasing</li>
                <li><strong>📦 Order tracking</strong> - Real-time updates on your purchases</li>
                <li><strong>👥 Community features</strong> - Connect with other ZMart members</li>
            </ul>

            <p>If you're having trouble clicking the button above, copy and paste the following link into your web browser:</p>
            <div class="code-block">${link}</div>

            <p>If you believe you received this invitation in error or need assistance, please contact our support team at <a href="mailto:${properties.supportEmail}">${properties.supportEmail}</a>.</p>

            <p><strong>Welcome to the ZMart family!</strong> We can't wait to see what you'll discover. 🎊</p>
        </div>

        <!-- Footer -->
        <div class="email-footer">
            <div class="company-info">
                <p><strong>${properties.companyName}</strong></p>
                <p>${properties.companyAddress}</p>
                <p>Phone: ${properties.companyPhone} | Email: <a href="mailto:${properties.supportEmail}">${properties.supportEmail}</a></p>
            </div>

            <div class="social-buttons">
                <a href="${properties.socialFacebook}" class="social-button facebook" target="_blank">f</a>
                <a href="${properties.socialTwitter}" class="social-button twitter" target="_blank">t</a>
                <a href="${properties.socialInstagram}" class="social-button instagram" target="_blank">i</a>
                <a href="${properties.socialLinkedin}" class="social-button linkedin" target="_blank">in</a>
            </div>

            <p>
                <a href="${properties.privacyUrl}" target="_blank">Privacy Policy</a> | 
                <a href="${properties.termsUrl}" target="_blank">Terms of Service</a>
            </p>

            <div class="unsubscribe">
                <p>This is an administrative invitation to join ZMart. If you don't wish to create an account, you can safely ignore this email.</p>
            </div>
        </div>
    </div>

    <style>
        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin: 1.5rem 0;
        }

        .benefit-item {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid #2563eb;
        }

        .benefit-item h4 {
            margin: 0 0 0.5rem 0;
            color: #1f2937;
            font-size: 1rem;
        }

        .benefit-item p {
            margin: 0;
            color: #4b5563;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        @media (max-width: 600px) {
            .benefits-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</body>
</html>