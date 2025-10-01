<#ftl output_format="HTML">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg("passwordResetSubject")}</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/email.css">
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
            <h1>${msg("passwordResetBodyHeader")}</h1>
            
            <p class="lead">${msg("passwordResetBodyGreeting", user.firstName!"")}</p>
            
            <p>${msg("passwordResetBody")}</p>

            <div class="btn-container">
                <a href="${link}" class="btn">${msg("passwordResetButton")}</a>
            </div>

            <div class="alert alert-warning">
                <strong>Security Notice:</strong> This password reset link will expire in <strong>${properties.codeExpirationMinutes} minutes</strong> for your security.
            </div>

            <div class="security-alert">
                <div class="icon">🔒</div>
                <h3>Didn't Request This?</h3>
                <p>If you didn't request a password reset, please ignore this email. Your password will remain unchanged and your account is secure.</p>
            </div>

            <h2>Account Security Tips</h2>
            <ul>
                <li>Use a strong, unique password that you don't use elsewhere</li>
                <li>Enable two-factor authentication if available</li>
                <li>Never share your password with anyone</li>
                <li>Log out of shared or public computers</li>
                <li>Contact us immediately if you notice suspicious activity</li>
            </ul>

            <p>If you're having trouble clicking the button above, copy and paste the following link into your web browser:</p>
            <div class="code-block">${link}</div>

            <p>For additional security assistance, please contact our support team at <a href="mailto:${properties.supportEmail}">${properties.supportEmail}</a>.</p>
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
                <p>You received this email because someone requested a password reset for this email address.</p>
                <p><a href="${properties.unsubscribeUrl}">Manage email preferences</a></p>
            </div>
        </div>
    </div>
</body>
</html>