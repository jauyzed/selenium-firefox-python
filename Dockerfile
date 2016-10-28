FROM ubuntu:trusty

RUN echo "deb http://ppa.launchpad.net/mozillateam/firefox-next/ubuntu trusty main" > /etc/apt/sources.list.d/mozillateam-firefox-next-trusty.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE49EC21

RUN apt-get update

RUN apt-get install -y firefox xvfb python-pip libdbus-glib-1-2 libgtk2.0-0 libasound2

RUN pip install selenium==3.0.1

RUN pip install pyvirtualdisplay

COPY geckodriver /

RUN mv -f geckodriver /usr/local/share/geckodriver
RUN ln -s /usr/local/share/geckodriver /usr/local/bin/geckodriver
RUN ln -s /usr/local/share/geckodriver /usr/bin/geckodriver

RUN mkdir -p /root/selenium_wd_tests

ADD google_test_ff.py /root/selenium_wd_tests

ADD xvfb.init /etc/init.d/xvfb

RUN chmod +x /etc/init.d/xvfb

RUN update-rc.d xvfb defaults

CMD (service xvfb start; export DISPLAY=:10; python /root/selenium_wd_tests/google_test_ff.py)
