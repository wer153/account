# 
FROM python:3.10-slim

# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.7.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
	&& $POETRY_VENV/bin/pip install -U pip setuptools \
	&& $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

WORKDIR /code

# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

# Copy Dependencies
COPY poetry.lock pyproject.toml ./
COPY ./manage.py /code/manage.py
COPY ./account /code/account

# [OPTIONAL] Validate the project is properly configured
RUN poetry check

# Install Dependencies
RUN poetry install --no-interaction --no-cache \
    && poetry run python /code/manage.py migrate

#
CMD ["poetry", "run", "uvicorn", "account.asgi:application", "--host", "0.0.0.0", "--port", "80"]
