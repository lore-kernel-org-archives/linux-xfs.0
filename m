Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 12:49:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NJmxm5010829
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99A76E2583B
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:40 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id MXA2RvzRHitSz1eC for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 12:49:40 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NJnUNg006564
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 21:49:30 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NJnUfj006562
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 21:49:30 +0200
Date: Wed, 23 Jul 2008 21:49:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 0/5] more vnode related macro cleanups
Message-ID: <20080723194930.GA6188@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

As Dave's cleanups got in so fast (thanks Niv!) I'll give these patches
a spin to.  They are all over so I'd love to get them in fast too and
get the leftover bhv_vnode_t bits sorted out ASAP.
