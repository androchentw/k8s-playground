FROM python:3.11-slim

ARG USER=appuser
ARG HOME=/home/$USER

WORKDIR $HOME

COPY ./requirements.txt "$HOME/requirements.txt"

RUN pip install --no-cache-dir --upgrade -r "$HOME/requirements.txt"

COPY ./app $HOME/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
