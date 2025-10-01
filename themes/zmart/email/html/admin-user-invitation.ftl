<#ftl output_format="HTML">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg("userInvitationSubject")}</title>
    <link rel="stylesheet" href="${url.resourcesPath}/css/email.css">
</head>
<body>
    <div class="email-container">
        <div class="email-header">
            <h1 class="logo">ZMart</h1>
            <p class="tagline">Your Ultimate E-commerce Experience</p>
        </div>

        <div class="email-body">
            <h1>${msg("userInvitationHeader")}</h1>
            
            <p class="lead">${msg("userInvitationGreeting")}</p>
            
            <p>${msg("userInvitationBody")}</p>

            <div class="btn-container">
                <a href="${link}" class="btn">${msg("userInvitationButton")}</a>
            </div>

            <div class="alert alert-warning">
                <strong>${msg("linkExpires")}</strong>
            </div>

            <p>${msg("userInvitationInstructions")}</p>
            <div class="code-block">${link}</div>

            <p>${msg("userInvitationSupport")}</p>
        </div>

        <div class="email-footer">
            <div class="company-info">
                <p><strong>ZMart</strong></p>
                <p>${msg("contactSupport")}</p>
            </div>
        </div>
    </div>
</body>
</html>