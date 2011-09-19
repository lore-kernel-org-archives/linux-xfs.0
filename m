Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JHAme6002401 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 12:10:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4D2F550A55
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 10:10:47 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ldXSuN6vs3vXAjuW for <xfs@oss.sgi.com>;
	Mon, 19 Sep 2011 10:10:47 -0700 (PDT)
Date: Mon, 19 Sep 2011 13:10:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: The xfsprogs debian package
Message-ID: <20110919171047.GA3092@infradead.org>
References: <20110919170936.GA27014@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110919170936.GA27014@infradead.org>
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
To: aurel32@debian.org, nathans@debian.org, anibal@debian.org
Cc: xfs@oss.sgi.com

[and now with the correct Cc list]

On Mon, Sep 19, 2011 at 01:09:36PM -0400, Christoph Hellwig wrote:
> Hi Aurelien, Nathan & Anibal,
> 
> is there any chance we can get to a defintive agreement on how to
> maintain the xfsprogs package?  So far the idea of releasing the
> upstream releases as Debian packages at the same time has worked
> great for both Debian, and us xfs developers (which to a large
> extents are heavy Debian users), but "inner" Debian circles heave
> always complained about it.
> 
> Can we please get an explanation of why it is so in proper written
> englush, instead of doing by forced nmus?
> 
> Also Nathan & Anibal - if there is no consesus for keeping the old
> scheme what about dropping it?  We can still keep the main Debian
> packaging in the tree, and find a way to generate a normally NULL
> Debian diff for it.  I'm not quite sure how to do it, but there
> must be some way.
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
