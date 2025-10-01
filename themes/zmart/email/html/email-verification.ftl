<#ftl output_format="HTML">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg("emailVerificationSubject")}</title>
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
            <h1>${msg("emailVerificationBodyHeader", user.firstName!"")}</h1>
            
            <p class="lead">${msg("emailVerificationBody")}</p>

            <div class="btn-container">
                <a href="${link}" class="btn">${msg("emailVerificationButton")}</a>
            </div>

            <div class="alert alert-info">
                <strong>Important:</strong> This verification link will expire in <strong>24 hours</strong>. If you don't verify your email within this time, you'll need to request a new verification email.
            </div>

            <h2>What's Next?</h2>
            <ul>
                <li>Browse our extensive catalog of products</li>
                <li>Create wishlists and save your favorite items</li>
                <li>Get exclusive access to member-only deals</li>
                <li>Enjoy fast and secure checkout</li>
                <li>Track your orders in real-time</li>
            </ul>

            <p>If you're having trouble clicking the button above, copy and paste the following link into your web browser:</p>
            <div class="code-block">${link}</div>

            <p>If you didn't create an account with ZMart, please ignore this email or <a href="mailto:${properties.supportEmail}">contact our support team</a>.</p>
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
                <p>You received this email because you created an account at ZMart.</p>
                <p><a href="${properties.unsubscribeUrl}">Unsubscribe from account emails</a></p>
            </div>
        </div>
    </div>
</body>
</html>