Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 05:56:22 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8CCtw4p006566
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 05:56:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8CCJdA5016929
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 14:19:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8CCJdRZ016927
	for xfs@oss.sgi.com; Wed, 12 Sep 2007 14:19:39 +0200
Date: Wed, 12 Sep 2007 14:19:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: state of the cvs tree
Message-ID: <20070912121938.GA16870@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

looks like the cvs tree is broken currently - fs/xfs/ is merged up to
2.6.23-rc, but everything else is still at 2.6.22-rc state leading to
various compile failures.
