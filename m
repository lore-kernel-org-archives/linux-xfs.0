Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PJw6aM149710 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 14:58:06 -0500
Date: Thu, 25 Oct 2012 14:59:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 1/4] [PATCH] dmapi: rename configure.in to configure.ac
Message-ID: <20121025195948.GX1377@sgi.com>
References: <20121025183634.486901001@sgi.com>
	<20121025183726.677374542@sgi.com> <5089977F.6050907@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5089977F.6050907@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Mike Frysinger <vapier@gentoo.org>, xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 02:48:15PM -0500, Mark Tinguely wrote:
> On 10/25/12 13:36, bpm@sgi.com wrote:
> >configure.in has been renamed to configure.ac.  Update the Makefile.
> >
> >Signed-off-by: Ben Myers<bpm@sgi.com>
> >---
> >  Makefile |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Add a:
> 
>  git mv configure.in configure.ac
> 
> Then:
> 
> Reviewed-by Mark Tinguely <tinguely@sgi.com>

Thank you kindly sir!

I've committed these four patches atop Mike's series.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
