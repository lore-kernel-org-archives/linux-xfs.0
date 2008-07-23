Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 22:59:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N5xoZd027670
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 22:59:51 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 739F0317B33
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 23:01:00 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id S2klGn8wOWkP9PBb for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 23:01:00 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6N60oNg031066
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 08:00:50 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6N60o4K031063
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 08:00:50 +0200
Date: Wed, 23 Jul 2008 08:00:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] dmapi: use ->put_listen callback directly
Message-ID: <20080723060050.GA30997@lst.de>
References: <20080603114848.GC2703@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603114848.GC2703@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Any reason this didn't get commited with the other patch from the
series?
