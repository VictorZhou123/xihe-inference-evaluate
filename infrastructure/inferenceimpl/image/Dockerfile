# real service
FROM python:3.9.13

USER root
RUN groupadd --gid 5000 mindspore \
  && useradd --home-dir /home/mindspore --create-home --uid 5000 --gid 5000 --shell /bin/sh --skel /dev/null mindspore

RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6 -y
RUN apt install libgl1-mesa-glx tini -y

USER mindspore
ENV PATH="${PATH}:/home/mindspore/.local/bin"
WORKDIR /usr/src/app

COPY --chown=mindspore:mindspore --chmod=550 ./run.sh ./run.sh
COPY --chown=mindspore:mindspore ./requirements.txt ./requirements.txt

RUN pip install --upgrade -i https://pypi.mirrors.ustc.edu.cn/simple pip
RUN pip install --default-timeout=1000 --user -i https://pypi.mirrors.ustc.edu.cn/simple -r requirements.txt
RUN rm -f ./requirements.txt
# TODO: what's the purpose
EXPOSE 7860

ENTRYPOINT ["tini", "--"]
CMD ["/usr/src/app/run.sh"]
