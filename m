Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATErfTk176441 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 08:53:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEB6D1DB4CB0
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 06:55:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CmM3eX6BC7jLHnxa for
	<xfs@oss.sgi.com>; Mon, 29 Nov 2010 06:55:23 -0800 (PST)
Date: Mon, 29 Nov 2010 09:55:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS repair utils
Message-ID: <20101129145523.GA22839@infradead.org>
References: <AANLkTikUOZJeSnSHO+pAM5d6DjWEPBdUSiua1dcv0pxt@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTikUOZJeSnSHO+pAM5d6DjWEPBdUSiua1dcv0pxt@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: naveen yadav <yad.naveen@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 07:30:50PM +0530, naveen yadav wrote:
> Hi All,
> 
> I am using XFS 2.6.34 kernel on my target, and I have
> #xfs_repair -V
> xfs_repair version 3.0.5
> 
> So is there any issue of compatibility with latest XFS_repair utils.
> or it will work fine with my latest kernel(2.6.34).

It works just fine, but the 3.1.x series of xfsprogs brings large
repair memory savings.

> Since some time mount fails.

What mount messages, what platform?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
