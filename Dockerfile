# 
FROM python:3.10-slim

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

COPY ./manage.py /code/manage.py

COPY ./account /code/account

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt && python /code/manage.py migrate


#
CMD ["uvicorn", "account.asgi:application", "--host", "0.0.0.0", "--port", "80"]
