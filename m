Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ3TGX2002670 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 21:29:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E50915FEF12
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:29:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UoXTxQHbEk7ZakR3 for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 19:29:16 -0800 (PST)
Date: Tue, 25 Nov 2008 22:28:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081126032844.GB19523@infradead.org>
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C9FB9.3090204@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <492C9FB9.3090204@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Nov 26, 2008 at 12:00:41PM +1100, Lachlan McIlroy wrote:
> We would prefer patches based on the master branch but patches can be
> against the mainline, master or xfs-dev branches.  If a patch against
> mainline or xfs-dev doesn't apply cleanly to the master branch we may
> ask the author to rebase that patch against the master branch.  If a
> patch to the master branch needs auxillary changes to files that only
> exist in the xfs-dev branch (ie xfsidbg stuff) we may ask for an
> additional patch from the author.

Seems like a complicated setup, and not very friendly to patch
submitters.  Why acn't we just submit all patches against the -dev
branch?  Especially for dmapi-related patches everything else will
be a real pain.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
