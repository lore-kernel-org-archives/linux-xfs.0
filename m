Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4DQk70032418 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 07:26:46 -0600
Date: Thu, 4 Dec 2008 08:26:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081204132645.GA32664@infradead.org>
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C9FB9.3090204@sgi.com> <20081126020009.GF6291@disturbed>
	<492CC287.3070709@sgi.com> <20081126040840.GG6291@disturbed>
	<492CE189.2000304@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <492CE189.2000304@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 26, 2008 at 04:41:29PM +1100, Timothy Shimmin wrote:
> I was just thinking that if an external developer is working on a clone of
> say the master branch and they have a fix, that they might post a patch
> and say where sgi can pull from (the developer's tree) to receive the patch(es)
> as an easier way to bring stuff in.

So do you want git trees or not now?  I spent quite some time to set up
a tree for my last set of patches, but what got in was slightly
different, so when I pulles I got a merge and duplicates in my tree and
had to git-reset to a point before my patches.  If you do apply from
the list anyway I can avoid that overhead.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
