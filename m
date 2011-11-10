Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAAGMDA6104383 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 10:22:13 -0600
Message-ID: <4EBBFA31.5040408@sgi.com>
Date: Thu, 10 Nov 2011 10:22:09 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/8] xfsdump: enable support for multiple streams
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<20111110110017.GA26747@infradead.org>
In-Reply-To: <20111110110017.GA26747@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> I've put these changes, and Mike's path.c fix in.  It seems like the
> whole autoconf/aclocal foo needs to be regenerated to make the
> libpthread substitution to work.
> 
> What is your schedule for turning on the tap ring buffer, and redoing
> the stream split scan?  Should we wait for them or aim for a release
> with the current improvements relatively quickly?

I haven't started working on any of that yet, and will be side tracked
with other work for a while. It's probably best not to hold a release
for those changes.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
