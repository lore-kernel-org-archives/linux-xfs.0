Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7kusI205044 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:46:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A365CB769E
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:45:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id arjPAwihT3jhjBOE for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:45:47 -0800 (PST)
Date: Mon, 26 Jan 2009 02:45:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: add xfs_estimate manpage
Message-ID: <20090126074547.GA27188@infradead.org>
References: <20090123004519.GA29225@infradead.org>
	<497C7718.5090607@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <497C7718.5090607@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Jan 25, 2009 at 08:28:40AM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > xfs_Estimate has been moved to xfsprogs a while ago, so the manpage
> > should follow it.
> 
> Hmm we need a patch to remove from dump too right :)

I already put that in.

> ACK for the move part, but some update to the man page to give a hint as
> to why this tool is useful seems reasonable... why would I want to use
> this thing?
> 
> Also as an aside, why does the log size matter for space ultimately used?

I have no idea what this tools is useful for.  It always seemed rather odd
to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
