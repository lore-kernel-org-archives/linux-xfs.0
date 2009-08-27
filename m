Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7RLIMKR111129 for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 16:18:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BF721567146
	for <xfs@oss.sgi.com>; Thu, 27 Aug 2009 14:18:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zEaNc3JIpG4vocmk for
	<xfs@oss.sgi.com>; Thu, 27 Aug 2009 14:18:52 -0700 (PDT)
Date: Thu, 27 Aug 2009 17:18:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add ext2/3/4-specific _check_extN_filesystem function
Message-ID: <20090827211848.GA9427@infradead.org>
References: <1250607467-15085-1-git-send-email-tytso@mit.edu>
	<20090818161116.GA2162@infradead.org>
	<20090818170456.GF28560@mit.edu>
	<20090826221201.GC18119@infradead.org>
	<20090827020533.GL6997@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090827020533.GL6997@mit.edu>
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
To: Theodore Tso <tytso@mit.edu>
Cc: xfs@oss.sgi.com

On Wed, Aug 26, 2009 at 10:05:33PM -0400, Theodore Tso wrote:
> Sorry, work has gotten busy and I'm trying to get some last patches
> whipped into shape before the merge window opens.  I probably won't
> have time to look at this for at least a week or two.  So if you want
> to merge this version in for now, I'll try to clean it up when I have
> a chance.

Ok, I've put it in now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
