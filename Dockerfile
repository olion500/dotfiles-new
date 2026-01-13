FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Create test user with sudo
RUN useradd -m -s /bin/zsh testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser

# Create empty .zshrc to prevent zsh-newuser-install wizard
RUN touch ~/.zshrc

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
ENV PATH="/home/testuser/.local/bin:$PATH"

CMD ["/bin/zsh"]
