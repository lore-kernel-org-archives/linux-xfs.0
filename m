Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OJ8Wf1160787 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 13:08:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A166714C098
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 11:08:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aCDc3GIzGhnx7IbC for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 11:08:02 -0800 (PST)
Date: Tue, 24 Feb 2009 14:07:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: rfc 1/2: specfile: use rpm macros where possible
Message-ID: <20090224190731.GA22910@infradead.org>
References: <alpine.LSU.2.00.0902111802320.25232@fbirervta.pbzchgretzou.qr>
	<20090215172417.GA20256@infradead.org>
	<alpine.LSU.2.00.0902191625070.20437@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0902191625070.20437@fbirervta.pbzchgretzou.qr>
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

On Thu, Feb 19, 2009 at 04:25:20PM +0100, Jan Engelhardt wrote:
> On Sunday 2009-02-15 18:24, Christoph Hellwig wrote:
> 
> >Thanks, I'll put these in.  Can you submit equivalent patches for
> >xfsdump and dmapi, too?
> >
> xfsdump and dmapi git repositories seem to have no .spec files.

build/rpm/xfsdump.spec.in and build/rpm/dmapi.spec.in

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
