Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n029wiDc016600 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 03:58:44 -0600
Date: Fri, 2 Jan 2009 04:58:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] XFS update for 2.6.29
Message-ID: <20090102095842.GA24652@infradead.org>
References: <20081230030845.A4F0558AE206@chook.melbourne.sgi.com>
	<Pine.LNX.4.64.0901011048090.14380@anakin>
	<20090101170329.GA17892@infradead.org>
	<Pine.LNX.4.64.0901021056360.14380@anakin>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901021056360.14380@anakin>
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Fri, Jan 02, 2009 at 10:57:43AM +0100, Geert Uytterhoeven wrote:
> > Hmm, can't reproduce it here with CONFIG_LBD=n on x86, but the following
> 
> x86-32 or -64?
> 
> It may also depend on the compiler version. I have gcc version 4.1.2 20061115
> (prerelease) (Debian 4.1.1-21).

32 bit, gcc version 4.3.2 (Debian 4.3.2-1) 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
