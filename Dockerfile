FROM alpine:3.7

ENV PATH /usr/local/bin:$PATH
ENV LANG C.UTF-8
ENV PYTHON_PIP_VERSION 10.0.0

RUN apk add --no-cache ca-certificates 

RUN set -ex \
	&& apk --no-cache add python3 wget bash nginx \ 
	&& apk --no-cache add --virtual .x-deps \ 
		gcc \
		g++ \
		gfortran \
		python3-dev \
		build-base \
		freetype-dev \
		libpng-dev \
		openblas-dev \
		linux-headers \
	\
	&& ln -s /usr/include/locale.h /usr/include/xlocale.h \
	&& wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
	&& python3 get-pip.py --disable-pip-version-check --no-cache-dir  "pip==$PYTHON_PIP_VERSION" \
	&& pip3 --version \
	&& rm -f get-pip.py \
	&& pip3 install --no-cache-dir --upgrade pip setuptools wheel \
	&& pip3 install --no-cache-dir -v pytz \
        && pip3 install --no-cache-dir -v 'pymysql>=0.8.0' \
        && pip3 install --no-cache-dir -v 'numpy==1.12.1' \
 	&& pip3 install --no-cache-dir -v Cython --install-option="--no-cython-compile" \
	&& pip3 install --no-cache-dir -v 'tornado>=3.0,<5.0' \
	&& pip3 install --no-cache-dir -v 'pyzmq>=13.1.0,<17.0' \
        && pip3 install --no-cache-dir -v gunicorn \
        && pip3 install --no-cache-dir -v circus \
        && pip3 install --no-cache-dir -v 'flask>=0.12.2' \
	\
	&& wget https://files.pythonhosted.org/packages/08/01/803834bc8a4e708aedebb133095a88a4dad9f45bbaf5ad777d2bea543c7e/pandas-0.22.0.tar.gz \
        && gzip -c -d pandas-0.22.0.tar.gz | tar x \
        && rm pandas-0.22.0.tar.gz \
	&& cd pandas-0.22.0 \
	&& mv pyproject.toml x && grep -v Cython x > pyproject.toml && rm x \
	&& python3 setup.py install \
        && cd .. \
        && rm -rf pandas-0.22.0 \
	; \
	apk del .x-deps 

COPY nginx.conf /etc/nginx/nginx.conf
COPY circus.conf /etc/circus.ini
COPY app /app
EXPOSE 80 5000
CMD ["circus", "/etc/circus.ini"]

