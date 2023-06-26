
FROM python:3.9.6-alpine
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

LABEL maintainer=" "

WORKDIR /app
RUN python -m env /opt/env
COPY requirements.txt requirements.txt
COPY entrypoint.sh entrypoint.sh
COPY . .
EXPOSE 8000

#CREATE A VIRTUAL ENV, INTALL REQUIREMENT.TXT, UPDATE PIP PACKAGE
RUN  python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r requirements.txt
    #useradd -m -s /bin/bash myapp
    
ENV PATH="entrypoint.sh:/py/bin:$PATH"
# #USER app
CMD ["sh", "entrypoint.sh"]
