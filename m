Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4CoD4G029040 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 06:50:15 -0600
Date: Thu, 4 Dec 2008 07:50:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
Message-ID: <20081204125006.GA13411@infradead.org>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0812040956370.10635@anakin>
	<20081204121330.GA18815@infradead.org>
	<20081204234603.b5a28cd6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081204234603.b5a28cd6.sfr@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>

On Thu, Dec 04, 2008 at 11:46:03PM +1100, Stephen Rothwell wrote:
> fs/xfs/linux-2.6/xfs_file.c:365: error: 'xfs_file_compat_invis_ioctl' undeclared here (not in a function)
> 
> Eric mentioned that your patch "had a problem of its own", so I assumed
> that was it and left it removed from today's linux-next.

Yeah, but Niv fixed it up and the correct version is not in the xfs git
tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
