# mitmdump -s mitmproxy_encrypted_logger.py
import json
import os
from datetime import datetime
from mitmproxy import ctx

def write_file(file_name, content):
  with open(file_name, "w") as f:
    f.write(content)

def log_content(req_path, direction, content):
  if not os.path.exists("encrypted_log"):
    os.makedirs("encrypted_log")

  timestamp = datetime.now().strftime("%Y%m%d_%H%M%S_%f")
  base_name = req_path[1:]

  # 20170927_211110_567-ticket_pay-req.json
  # 20170927_211110_578-ticket_pay-res.json
  log_file_name = "%s-%s-%s.json" % (timestamp, base_name, direction)
  write_file("encrypted_log/" + log_file_name, content)

def request(flow):
  if flow.request.host == "cxb.ac.capcom.jp":
    content = json.dumps(dict(flow.request.urlencoded_form.items()), sort_keys=True)

    ctx.log.info('> %s' % (flow.request.path))
    log_content(flow.request.path, "req", content)

def response(flow):
  if flow.request.host == "cxb.ac.capcom.jp":
    content = flow.response.content.decode('ascii')

    ctx.log.info('< %s' % (flow.request.path))
    log_content(flow.request.path, "res", content)
