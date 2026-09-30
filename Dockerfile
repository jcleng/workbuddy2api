# 国内直连 docker.io 拉取超时，改用华为云镜像源
FROM swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY converter.py responses_adapter.py anthropic_adapter.py desensitize.py wb_install.py ./
# admin 服务跑 `uvicorn admin.server:app`，而 admin 包 import 了
# converter / wb_install / turing_helper.js，converter 也 import 了 admin.client_profile。
# 不 COPY admin/ 的话两个服务都会 ModuleNotFoundError。
COPY admin ./admin
COPY turing_helper.js ./turing_helper.js

EXPOSE 8787 8790

CMD ["python3", "converter.py", "--host", "0.0.0.0", "--port", "8787", "--skip-check"]
