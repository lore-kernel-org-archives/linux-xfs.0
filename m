Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 12:21:15 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m62JL6pF024974
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 12:21:07 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B652E186317B
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 12:22:08 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id BegmWCwKjpfuogWC for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 12:22:08 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m62JLxNW018879
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 21:21:59 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m62JLxEW018877
	for xfs@oss.sgi.com; Wed, 2 Jul 2008 21:21:59 +0200
Date: Wed, 2 Jul 2008 21:21:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: "a" and "foo" files in the top dir of linux-2.6-xfs
Message-ID: <20080702192159.GA18817@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There's two empty files named "a" and "foo" in the top level directory
of linux-2.6-xfs.  cvs log claims they're Niv's faul with some really
strange commit messages..
