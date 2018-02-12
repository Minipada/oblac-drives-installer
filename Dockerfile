FROM python:2.7

RUN pip install ansible==2.4
RUN pip install boto==2.48.0
RUN pip install awscli==1.14.36
