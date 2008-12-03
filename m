Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3HDV8n001792 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 11:13:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFD42167A6E5
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 09:13:30 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id THmTdX8BlMCQazKy for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 09:13:30 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7vHY-0000xs-0z
	for xfs@oss.sgi.com; Wed, 03 Dec 2008 17:13:00 +0000
Date: Wed, 3 Dec 2008 12:13:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/22] 2.6.29 queue
Message-ID: <20081203171300.GA17773@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202160430.775774000@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

On Tue, Dec 02, 2008 at 11:04:30AM -0500, Christoph Hellwig wrote:
> This is my current 2.6.29 queue.  All but a few trivial patches have already
> been posted to the list.  I have another two patches for 2.6.29 in progress
> that aren't included but should go to the list in a few days.
> 
> Note that this is a series against the master tree, patches against dmapi or
> xfsidbg aren't included (and not relevant for 2.6.29).

The 20 patches that have been reviewed are now available in a git
repository:

	http://git.kernel.org/?p=linux/kernel/git/hch/xfs.git

	git://git.kernel.org/pub/scm/linux/kernel/git/hch/xfs.git

This includes all the small fixups suggested by Dave, and all the
reviewed-by tags.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
