Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 05:00:47 -0800 (PST)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1BD0eJ9006784
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 05:00:40 -0800
Message-ID: <47B04706.8010002@sgi.com>
Date: Tue, 12 Feb 2008 00:00:54 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [review] Remove the xfs refcache
References: <4765EC66.5020202@sgi.com> <20080207083554.GA11119@infradead.org>
In-Reply-To: <20080207083554.GA11119@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Dec 17, 2007 at 02:26:30PM +1100, Donald Douwsma wrote:
>> Remove the xfs_refcache, it was only needed while we were still building for
>> 2.4 kernels.
> 
> Given that we finally agreed that this form of refcache shouldn't come
> back can you commit the patch?

Done. I'll see if we can get it committed with the Makefile cleanups, that
should be the end of the 2.4 crud.

Don
