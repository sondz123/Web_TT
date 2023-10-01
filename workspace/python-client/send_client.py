import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import os
import queue
import requests

def sendFile(url, path):
  print(path)
  files=[
    ('dataFile',(os.path.basename(path), open(path,'rb'), 'binary/octet-stream'))
  ]

  response = requests.request("POST", url, files=files)
  if response.status_code != 200:
    raise response.raise_for_status()
  return response

q = queue.Queue()
URL = 'http://localhost:8000/uploads'

class Handler(FileSystemEventHandler):
  def on_created(self, event):
    time.sleep(2)
    q.put(event.src_path)

if __name__ == '__main__':
  folder_to_track = os.getcwd()
  event_handler = Handler()
  observer = Observer()
  observer.schedule(event_handler, folder_to_track, recursive=True)
  observer.start()
  try:
    while True:
      fName = q.get()
      print(f'send file {fName} to server')
      try:
        time.sleep(1)
        response = sendFile(URL, fName)
        print(response.text);
      except Exception as e:
        print("Error")
        print(e)

  except Exception as e:
    print("Have an error: ", e)
  finally:
    observer.stop()
    observer.join()
