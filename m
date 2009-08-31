Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7VImPrc116696 for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 13:48:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B68111591F58
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:49:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r6DAAFoHYmqcO3dW for
	<xfs@oss.sgi.com>; Mon, 31 Aug 2009 11:49:20 -0700 (PDT)
Date: Mon, 31 Aug 2009 14:49:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs compat_ioctl?
Message-ID: <20090831184918.GB10393@infradead.org>
References: <4A9B759B.7020401@msgid.tls.msk.ru>
	<20090831123010.GA2368@infradead.org>
	<20090831183751.GC19343@comcast.net>
	<20090831184822.GA10393@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090831184822.GA10393@infradead.org>
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
To: Tim Walberg <twalberg@comcast.net>, Christoph Hellwig <hch@infradead.org>, Michael Tokarev <mjt@tls.msk.ru>, Linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 31, 2009 at 02:48:22PM -0400, Christoph Hellwig wrote:
> On Mon, Aug 31, 2009 at 01:37:51PM -0500, Tim Walberg wrote:
> > Linux sparcy 2.6.30.4-sparcy #2 Sat Aug 1 21:14:46 CDT 2009 sparc64 GNU/Linux
> > sparcy:~# file $(which xfs_fsr)
> > /usr/sbin/xfs_fsr: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
> 
> I'll take a look at that, thanks.

Err, sorry - is that with the patch I posted in this thread or without?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
