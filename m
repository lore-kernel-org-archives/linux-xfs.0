Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n139TxWd050852 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 03:29:59 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A26ADE0E2
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 01:29:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gcbmE1wWqjJ5zCev for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 01:29:19 -0800 (PST)
Date: Tue, 3 Feb 2009 04:29:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: Bug#513821: xfsprogs: xfs_growfs does not work]
Message-ID: <20090203092919.GA31741@infradead.org>
References: <1233641256.5518.83.camel@verge.scott.net.au>
	<1233641336.5518.85.camel@verge.scott.net.au>
	<20090203062036.GA23098@infradead.org> <200902031024.53548@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902031024.53548@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Feb 03, 2009 at 10:24:53AM +0100, Michael Monnerie wrote:
> On Dienstag 03 Februar 2009 Christoph Hellwig wrote:
> > > and "Kernel: Linux 2.6.26-1-amd64 (SMP w/1 CPU core)" to save ya
> > > looking.
> >
> > 2.6.16 didn't have the compat ioctl handler for growfs yet, and this
> > is i386 xfsprogs on a 64bit kernel. ?He needs to upgrade to a more
> > recent kernel.
> 
> He wrote 2.6.26....

And I did mean 2.6.26, sorry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
