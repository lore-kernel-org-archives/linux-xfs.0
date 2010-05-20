Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KHBudV217252 for <xfs@oss.sgi.com>; Thu, 20 May 2010 12:11:57 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74E9F3602DC
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 10:14:15 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id WuvuHVbnljtF5JYP for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 10:14:15 -0700 (PDT)
Date: Thu, 20 May 2010 19:14:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/7] xfstests: test extent size hints
Message-ID: <20100520171408.GF3395@quack.suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
	<1274276289-8839-2-git-send-email-jack@suse.cz>
	<20100520150141.GA27124@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100520150141.GA27124@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu 20-05-10 11:01:42, Christoph Hellwig wrote:
> I think you included one patch too many in your series, this was already
  Yes, I've noticed that as well. Sorry for that.

> applied.  Btw, if you have this in a git tree making that available
> would ease testing a bit.
  OK. It's at
git://git.kernel.org/pub/scm/linux/kernel/git/jack/xfstests-dev/
  in branch quota-tests
  (I know it's inappropriate place but I'm too lazy to setup the repository
somewhere else ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
