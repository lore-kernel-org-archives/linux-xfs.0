Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B651E7F4E
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 05:00:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 252C8AC004
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 03:00:27 -0800 (PST)
Date: Wed, 4 Dec 2013 03:00:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] xfsprogs v3.2.0-alpha2
Message-ID: <20131204110023.GA3263@infradead.org>
References: <5293A699.20908@sgi.com> <20131128104002.GC26927@infradead.org>
	<20131128211858.GR10988@dastard>
	<20131129080538.GA31310@infradead.org>
	<20131203221714.GY10988@dastard> <20131203224354.GR1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131203224354.GR1935@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 03, 2013 at 04:43:54PM -0600, Ben Myers wrote:
> IIRC last time we discussed this I expressed a preference for focussing
> on the 3.2.0 release, but did not object to a 3.1.12 either.  I think
> Eric followed up and asked if Christoph had specific concerns that
> should prompt a 3.1.12 release.  Now I think it's probably just best to
> focus on the xfs_repair bits for 3.2.0.

My concern is pretty simple: we have a big batch of minor and not so
minor fixes that I want to get out to our users.  We've done releases
about every 3 month for the last couple years, but we've not done any
for 6 month by now.

I have to admit I'm a bit out of the loop on the v5 repair work, but if
Dave feels confident that he can get it done soon we should aim for a
3.2.0 release after that.  If not it's more than time to get a 3.1.12
out and I'd be happy to do the work for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
