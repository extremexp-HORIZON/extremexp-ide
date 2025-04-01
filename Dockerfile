FROM node:22

RUN curl -fsSL https://code-server.dev/install.sh | sh

# build our extension
WORKDIR /etc/xxp-lang-server
COPY . .

WORKDIR /etc/xxp-lang-server/client/vs-code
RUN npm install
RUN npm install -g @vscode/vsce
RUN npm uninstall xxp-language
RUN vsce package --allow-missing-repository --skip-license


# We want to have a user for the code server, where they cannot stop the server
RUN useradd -m -g root -s /bin/bash user && \
    echo "user:password" | chpasswd && \
    mkdir -p /home/user/workspace && \
    mkdir -p /etc/xxp-lang-server/logs && \
    chown -R user:root /home/user/workspace && \
    chown -R user:root /etc/xxp-lang-server/logs

# another attempt with the scripts to be run by the user
COPY ./run.sh /home/user/.run.sh
RUN cp  /etc/xxp-lang-server/client/vs-code/xxp-language-0.0.1.vsix /home/user/xxp-language-0.0.1.vsix
RUN chown user:root /home/user/.run.sh && chmod +x /home/user/.run.sh


EXPOSE 8080

# Switch back to the user user
USER user

# optional 
WORKDIR /home/user/workspace
RUN code-server --install-extension /home/user/xxp-language-0.0.1.vsix

# A better way is that we run this as user with su -c user <script>, but it works for now
CMD ["bash", "-c", "/home/user/.run.sh"]

