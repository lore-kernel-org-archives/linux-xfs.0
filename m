Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUHtZLY031472 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 11:55:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 722651797C92
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 09:55:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ESLjnoRGi6PaftH6 for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 09:55:35 -0800 (PST)
Date: Tue, 30 Dec 2008 12:55:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs-cmds git tree re-imported
Message-ID: <20081230175533.GA24980@infradead.org>
References: <49595778.6000200@thebarn.com>
	<20081230174610.GN6284@josefsipek.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081230174610.GN6284@josefsipek.net>
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
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 30, 2008 at 12:46:10PM -0500, Josef 'Jeff' Sipek wrote:
> On Mon, Dec 29, 2008 at 05:04:24PM -0600, Russell Cattelan wrote:
> > Based on Christoph's work to the xfs-authors list and his fix to cvsps
> > that can now accurately detect ptools changes sets the xfs-cmds tree
> > has been re-imported to git.
> > 
> > Please see for more info on the git trees in general.
> > http://xfs.org/index.php/Getting_the_latest_source_code
> > 
> > Note a new clone of the xfs-cmds tree  is required since this is a fresh 
> > import and does not share any commit data with the old import of xfs-cmds.
> 
> Is this going to be _the_ tree to use?

Yes.  Or if you want to be bleeding edge use:

	http://git.kernel.org/?p=fs/xfs/xfsprogs-dev.git

which is a clone of the above with all the patches from the list that
have been reviewed commited, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
