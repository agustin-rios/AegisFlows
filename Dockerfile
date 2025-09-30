ARG KC_VERSION=26.1.2
FROM quay.io/keycloak/keycloak:${KC_VERSION} AS builder

# Build-time environment variables
ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_DB=postgres \
    KC_HTTP_RELATIVE_PATH=/auth \
    KC_FEATURES="preview,admin-fine-grained-authz,token-exchange,declarative-user-profile"

WORKDIR /opt/keycloak

# Install custom providers if any
# COPY providers/*.jar /opt/keycloak/providers/

# Create secure keystore for production (replace with real certificates in production)
RUN keytool -genkeypair \
    -storepass changeit \
    -storetype PKCS12 \
    -keyalg RSA \
    -keysize 4096 \
    -dname "CN=keycloak-server,OU=IT,O=YourOrg,L=YourCity,ST=YourState,C=US" \
    -alias server \
    -ext "SAN:c=DNS:localhost,DNS:keycloak,IP:127.0.0.1" \
    -keystore conf/server.keystore \
    -validity 3650

# Build optimized Keycloak
RUN /opt/keycloak/bin/kc.sh build --cache=ispn --cache-config-file=cache-ispn-jdbc-ping.xml

# Runtime stage
FROM quay.io/keycloak/keycloak:${KC_VERSION}

# Copy built artifacts from builder stage
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Runtime environment variables
ENV KC_DB=postgres \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    KC_HTTP_RELATIVE_PATH=/auth \
    KC_PROXY=edge \
    KC_HOSTNAME_STRICT=true \
    KC_HOSTNAME_STRICT_HTTPS=true

# Create non-root user for security
USER 1000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:9000/health/ready || exit 1

EXPOSE 8080 8443 9000

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized", "--import-realm"]