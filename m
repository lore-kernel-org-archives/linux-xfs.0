Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 May 2007 03:52:48 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l42AqhfB021110
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 03:52:44 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l42AqgmK016050
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 2 May 2007 12:52:42 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l42Aqfmi016048
	for xfs@oss.sgi.com; Wed, 2 May 2007 12:52:41 +0200
Date: Wed, 2 May 2007 12:52:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Bug 756]  New: File data corruption when writing to files with DM_EVENT_WRITE enabled over NFS (2.4 kernel)
Message-ID: <20070502105241.GA15399@lst.de>
References: <200705012104.l41L4CI3029767@oss.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705012104.l41L4CI3029767@oss.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

> Note that a similar issue existed in the 2.6 SGI kernel up until it was resolved
> by this recent change:
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c.diff?r1=1.258;r2=1.259;f=h

Seems like someone forgot to send TAKEs to the xfs list once again..
