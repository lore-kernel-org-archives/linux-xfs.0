Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CFEA800E
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:24:23 -0500 (CDT)
Date: Wed, 21 Aug 2013 15:24:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] powerpc/spufs: convert userns uid/gid mount options to
	kuid/kgid
Message-ID: <20130821202417.GN5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130821155654.GI5262@sgi.com>
	<20130821143351.5840d556@oracle.com>
	<201308212205.27789.arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201308212205.27789.arnd@arndb.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeremy Kerr <jk@ozlabs.org>, Dwight Engen <dwight.engen@oracle.com>, Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>, linuxppc-dev@lists.ozlabs.org

On Wed, Aug 21, 2013 at 10:05:27PM +0200, Arnd Bergmann wrote:
> On Wednesday 21 August 2013, Dwight Engen wrote:
> > 
> > Acked-by: Jeremy Kerr <jk@ozlabs.org>
> > Tested-by: Jeremy Kerr <jk@ozlabs.org>
> > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Applied.

Thanks,
	-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
