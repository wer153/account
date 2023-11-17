FROM python:3.10-slim as requirements-stage
WORKDIR /tmp
# https://python-poetry.org/docs#ci-recommendations
ENV POETRY_VERSION=1.7.1
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv
# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"
# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache
# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
	&& $POETRY_VENV/bin/pip install -U pip setuptools \
	&& $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}
# Copy Dependencies
COPY poetry.lock pyproject.toml ./
RUN poetry export -f requirements.txt --output requirements.txt --without-hashes
# Validate the project is properly configured
RUN poetry check


FROM python:3.10-slim
WORKDIR /code
# Copy Dependencies
COPY --from=requirements-stage /tmp/requirements.txt /code/requirements.txt
COPY ./manage.py /code/manage.py
COPY ./account /code/account
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt && python /code/manage.py migrate
CMD ["uvicorn", "account.asgi:application", "--host", "0.0.0.0", "--port", "80"]
