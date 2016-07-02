import argparse
import os
import urllib2
import subprocess
import signal
import webbrowser


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("-b", "--build", action="store_true",
                        help=r"Run ant in appinventor-sources\appinventor")
    return parser.parse_args()

def build_appinventor_war():
    os.environ["_JAVA_OPTIONS"] = "-Xmx1024M"
    os.chdir(os.environ["USERPROFILE"] + r"\appinventor-sources\appinventor")
    return os.system(os.environ["ANT_HOME"] + r"\bin\ant")

def run_local_build_server():
    os.environ["_JAVA_OPTIONS"] = "-Xmx1024M"
    os.chdir(os.environ["USERPROFILE"] + r"\appinventor-sources\appinventor\buildserver")
    return subprocess.Popen(
        [os.environ["ANT_HOME"] + r"\bin\ant.bat", "RunLocalBuildServer"]
        )

def is_build_server_running():
    try:
        response = urllib2.urlopen("http://localhost:9990/buildserver/health")
        html = response.read()
        return html == "ok"
    except urllib2.URLError:
        return False

def start_appinventor():
    os.environ["_JAVA_OPTIONS"] = "-Xmx1024M"
    os.chdir(os.environ["USERPROFILE"] + r"\appinventor-sources\appinventor")
    return subprocess.Popen(
        [os.environ["LOCALAPPDATA"] + r"\appengine-java-sdk-1.9.27\bin\dev_appserver.cmd",
         "--port=8888", "--address=0.0.0.0", r"appengine\build\war"]
        )

def is_app_inventor_running():
    # I'm going to assume that if I can contact the server, that it's online
    try:
        response = urllib2.urlopen("http://localhost:8888/")
        html = response.read()
        return True
    except urllib2.URLError:
        return False

def taskkill(pid):
    subprocess.call(["taskkill", "/F", "/T", "/PID", str(pid)])

def main():
    try:
        buildServer = run_local_build_server()
        while not is_build_server_running():
            print "[build server] BOOTING"
        print "[build server] ONLINE"

        appInventor = start_appinventor()
        while not is_app_inventor_running():
            print "[app inventor] BOOTING"
        print "[app inventor] ONLINE"

        print "[app inventor] OPENING"
        try:
            browser = webbrowser.get("chrome")
        except webbrowser.Error:
            try:
                webbrowser.register("firefox", None, webbrowser.GenericBrowser(os.environ["ProgramFiles"] + r"\Mozilla Firefox\firefox.exe"), 1)
                browser = webbrowser.get("firefox")
            except webbrowser.Error:
                browser = webbrowser.get()
        browser.open("http://localhost:8888/_ah/login?continue=http://localhost:8888/")
    except Exception as e:
        print type(e)
        print e
    finally:
        taskkill(buildServer.pid)
        taskkill(appInventor.pid)


if __name__ == '__main__':
    args = parse_arguments()
    if args.build:
        print "PATH: " + os.environ["PATH"]
        build_appinventor_war()
    else:
        main()
    
