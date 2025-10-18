FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install required packages for Alpine Linux
RUN apk add --no-cache python3 py3-pip curl py3-msgpack ffmpeg imagemagick font-noto
RUN npm install -g cheerio axios lodash moment

# Create the directory structure for fonts if it doesn't exist
RUN mkdir -p /usr/share/fonts/truetype

# Copy Noto fonts to the expected location
RUN if [ -d /usr/share/fonts/noto ] && [ "$(ls -A /usr/share/fonts/noto)" ]; then \
      cp -r /usr/share/fonts/noto/* /usr/share/fonts/truetype/; \
      echo "Noto fonts copied to /usr/share/fonts/truetype/"; \
    else \
      echo "Noto fonts directory /usr/share/fonts/noto not found or is empty. Skipping copy."; \
    fi

# Optional: Rebuild font cache if fc-cache is available
RUN if command -v fc-cache > /dev/null; then \
      echo "Rebuilding font cache..."; \
      fc-cache -f -v; \
    else \
      echo "fc-cache not found, skipping font cache rebuild."; \
    fi

# Switch back to node user
USER node
