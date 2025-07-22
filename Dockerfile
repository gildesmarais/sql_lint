FROM ruby:3.3.8-slim-bullseye

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    BUNDLE_JOBS=$(nproc) \
    BUNDLE_RETRY=3 \
    BUNDLE_APP_CONFIG=/usr/local/bundle

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    sudo \
    git \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID -g $USERNAME -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the working directory and ensure ownership
WORKDIR /app
RUN chown $USERNAME:$USERNAME /app

# Switch to the non-root user
USER $USERNAME

# Copy Gemfile and .gemspec for dependency caching
COPY --chown=$USERNAME:$USERNAME Gemfile sql_lint.gemspec ./

# Install Bundler and gems
RUN bundle install

# Copy the rest of the application code
COPY --chown=$USERNAME:$USERNAME . .

CMD ["sleep", "infinity"]
