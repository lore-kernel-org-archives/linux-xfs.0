Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 07:44:47 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54EihWt020893
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 07:44:45 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l54Eifo6009791
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 16:44:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l54EifIt009789
	for xfs@oss.sgi.com; Mon, 4 Jun 2007 16:44:41 +0200
Date: Mon, 4 Jun 2007 16:44:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: state of the testsuite
Message-ID: <20070604144441.GA9672@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

When running the testsuite on Debian -testing I constanyly get the
12 failing testcases (016 041 049 064 071 082 084 104 111 136 140 166).
Is this expected or are other people seeing better results?
