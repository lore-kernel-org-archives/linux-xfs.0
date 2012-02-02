Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12BaAJP047929 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 05:36:10 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uvPegEbsqXuonfoE (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 03:36:09 -0800 (PST)
Date: Thu, 2 Feb 2012 06:36:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsprogs: extend fiemap configure check
Message-ID: <20120202113608.GB20525@infradead.org>
References: <519369070.69746.1328051417713.JavaMail.root@acxmail-au2.aconex.com>
	<1247398017.69749.1328051476851.JavaMail.root@acxmail-au2.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1247398017.69749.1328051476851.JavaMail.root@acxmail-au2.aconex.com>
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
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com

On Wed, Feb 01, 2012 at 10:11:16AM +1100, Nathan Scott wrote:
> Make the fiemap configure check consistent with the other
> libc interface checks - perform a compile and link with a
> complete set of symbols, macros and interfaces needed, as
> opposed to a build with just the headers.
> 
> Signed-off-by: Nathan Scott <nathans@debian.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
