Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 06:44:16 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l15EiB3c021399
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 06:44:12 -0800
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l15EhGDW024352
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 08:43:17 -0600
Subject: TAKE 960791 - Fix assertion in xfs_attr_shortform_remove()
Message-Id: <20070205150038.3E9325801C@lab41.emea.sgi.com>
Date: Mon,  5 Feb 2007 15:00:38 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Fix assertion in xfs_attr_shortform_remove().

Date:  Tue Feb  6 01:40:20 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-32.emea.sgi.com:/home/lachlan/isms/2.6.x-null
Inspected by:  bnaujok
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28021a
fs/xfs/xfs_attr_leaf.c - 1.106 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.106&r2=text&tr2=1.105&f=h
	- Fix assertion in xfs_attr_shortform_remove().
