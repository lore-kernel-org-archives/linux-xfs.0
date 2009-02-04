Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14Je547168590 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 13:40:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BE92E88A4
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 11:39:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id u9WIQ6AseYTuGopl for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 11:39:26 -0800 (PST)
Date: Wed, 4 Feb 2009 14:38:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: A rescue tool: xfs_irecover
Message-ID: <20090204193855.GB26436@infradead.org>
References: <alpine.LSU.2.00.0812292059020.15355@fbirervta.pbzchgretzou.qr>
	<20090204082816.GA9111@infradead.org>
	<alpine.LSU.2.00.0902041032510.27900@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0902041032510.27900@fbirervta.pbzchgretzou.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 10:33:28AM +0100, Jan Engelhardt wrote:
> On Wednesday 2009-02-04 09:28, Christoph Hellwig wrote:
> 
> >I looked into importing this into xfsprogs, and from a quick look
> >it could be simplified a lot by using code from libxfs or maybe even
> >by merging it into xfs_db and using the infrastructure there.
> >
> >But xfsprogs is licensed under GPLv2 and will stay that way as it shares
> >a lot of code with the kernel.  Are you willing to relicense the tool
> >under GPLv2 or later?
> 
> Yes; I updated the repository to reflect this (and add a manpage).

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
