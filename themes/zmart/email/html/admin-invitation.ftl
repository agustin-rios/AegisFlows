<#ftl output_format="HTML">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ZMart - Administrator Invitation</title>
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
            <h1>🎉 You've been invited to join ZMart!</h1>
            
            <p class="lead">Hello there!</p>
            
            <p>You have been personally invited by an administrator to join the <strong>ZMart E-commerce Platform</strong>. We're excited to welcome you to our growing community!</p>

            <div class="alert alert-info">
                <strong>📧 Invitation Details:</strong><br>
                Email: <strong>${user.email}</strong><br>
                Invited by: <strong>${inviterName!"ZMart Administrator"}</strong><br>
                Date: <strong>${.now?string("MMMM dd, yyyy")}</strong>
            </div>

            <h2>🚀 Complete Your Registration</h2>
            <p>To activate your account and complete your profile, please click the button below:</p>

            <div class="btn-container">
                <a href="${link}" class="btn">Complete Registration</a>
            </div>

            <div class="alert alert-warning">
                <strong>⏰ Time Sensitive:</strong> This invitation link will expire in <strong>7 days</strong>. Please complete your registration as soon as possible.
            </div>

            <h2>📋 What happens next?</h2>
            <p>After clicking the registration link, you'll be guided through a simple 3-step process:</p>
            
            <div class="account-details">
                <table>
                    <tr>
                        <th style="text-align: center;">Step</th>
                        <th>Action</th>
                        <th>Description</th>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>1</strong></td>
                        <td><strong>🔗 Link Google Account</strong></td>
                        <td>Connect your Google account for easy sign-in and profile setup</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>2</strong></td>
                        <td><strong>🔗 Link GitHub Account</strong></td>
                        <td>Connect your GitHub account for development features and social proof</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;"><strong>3</strong></td>
                        <td><strong>✅ Complete Profile</strong></td>
                        <td>Fill in your personal details and preferences</td>
                    </tr>
                </table>
            </div>

            <h2>🔐 Why do we need account linking?</h2>
            <ul>
                <li><strong>Google Account</strong>: Provides secure authentication and access to your profile information</li>
                <li><strong>GitHub Account</strong>: Enables developer features, social validation, and professional networking</li>
                <li><strong>Single Sign-On</strong>: Once linked, you can use any of these accounts to sign in seamlessly</li>
                <li><strong>Enhanced Security</strong>: Multi-factor authentication and reduced password fatigue</li>
            </ul>

            <div class="security-alert">
                <div class="icon">🛡️</div>
                <h3>Your Privacy Matters</h3>
                <p>We only access basic profile information needed for your ZMart account. You maintain full control over your data and can unlink accounts at any time.</p>
            </div>

            <p>If you're having trouble clicking the button above, copy and paste the following link into your web browser:</p>
            <div class="code-block">${link}</div>

            <p>If you believe you received this invitation in error or need assistance, please contact our support team at <a href="mailto:${properties.supportEmail}">${properties.supportEmail}</a>.</p>

            <p>Welcome to the ZMart family! 🎊</p>
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
                <p>This is an administrative invitation. If you don't wish to join ZMart, you can safely ignore this email.</p>
            </div>
        </div>
    </div>
</body>
</html>