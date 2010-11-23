Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANDJSVP212235 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 07:19:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DEEE21DB1D4F
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 05:21:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GpWgsAomnqN63Vrw for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 05:21:06 -0800 (PST)
Date: Tue, 23 Nov 2010 08:21:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.34 - XFS crash radix_tree_tag_set
Message-ID: <20101123132104.GA15462@infradead.org>
References: <AANLkTimNBapoCGa--2+PDME0q4nD5soLEudznHjFVB84@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTimNBapoCGa--2+PDME0q4nD5soLEudznHjFVB84@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Nov 23, 2010 at 03:50:37PM +0530, Ajeet Yadav wrote:
> I have the following backtrace on my ARM target, please have a look

Are sure you're on 2.6.34?  Something similar was fixed by commit 
f1f724e4b523d444c5a598d74505aefa3d6844d2 in 2.6.34.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
