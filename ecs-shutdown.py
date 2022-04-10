# -*- coding:utf-8 -*-

import ssl
import time,sys
from openstack import connection
from threading import Thread

ssl._create_default_https_context = ssl._create_unverified_context

def handler(event, context):
    projectId = context.getProjectID().strip()
    region = context.getUserData('region', '').strip()
    ak = context.getAccessKey().strip()
    sk = context.getSecretKey().strip()
    whiteList = context.getUserData('white_list', '').strip().split(',')
    if not projectId:
        raise Exception("'project_id' not configured")

    if not region:
        raise Exception("'region' not configured")

    if not ak or not sk:
        ak = context.getUserData('ak', '').strip()
        sk = context.getUserData('sk', '').strip()
        if not ak or not sk:
            raise Exception("ak/sk empty")

    logger = context.getLogger()
    _shutdown_ecs(logger, projectId, region, ak, sk, whiteList)

def _shutdown_ecs(logger, projectId, region, ak, sk, whiteList):
    conn = connection.Connection(project_id=projectId, domain='prod-cloud-ocb.orange-business.com', region=region, ak=ak, sk=sk)
    threads = []
    servers = conn.compute.servers()
    for server in servers:
        if server.name in whiteList:
            logger.info("skip stopping server '%s' for being in white lists." % (server.name))
            continue
        if "ACTIVE" != server.status:
            logger.info("skip stopping server '%s' for status not active(status: %s)." % (server.name, server.status))
            continue

        t = Thread(target=_stop_server,args=(conn, server, logger) )
        t.start()
        threads.append(t)

    if not threads:
        logger.info("no servers to be stopped.")
        return

    logger.info("'%d' server(s) will be stopped.", len(threads))

    for t in threads:
        t.join()

def _stop_server(conn, server, logger):
    logger.info("stop server '%s'..." % (server.name))
    conn.compute.stop_server(server)

    cost = 0
    interval = 5
    wait = 600
    while cost < wait:
        temp = conn.compute.find_server(server.id)
        if temp and "SHUTOFF" != temp.status:
            time.sleep(interval)
            cost += interval
        else:
            break

    #conn.compute.wait_for_server(server, status="SHUTOFF", interval=5, wait=600)
    if cost >= wait:
        logger.warn("wait for stopping server '%s' timeout." % (server.name))
        return 2

    logger.info("stop server '%s' success." % (server.name))
    return 0
