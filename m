Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBB0NZCT013527 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 18:23:35 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Sqi3OjW4Q6Wc7zrM for <xfs@oss.sgi.com>;
	Mon, 10 Dec 2012 16:26:03 -0800 (PST)
Date: Tue, 11 Dec 2012 11:25:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS write cache flush policy
Message-ID: <20121211002554.GQ15784@dastard>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <20121210005820.GG15784@dastard>
	<20121210091239.GA21114@citd.de> <50C64C17.9080206@sandeen.net>
	<20121210214511.GA32466@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121210214511.GA32466@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Lin Li <sdeber@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, Dec 10, 2012 at 10:45:11PM +0100, Matthias Schniedermeyer wrote:
> > >> Did you run repair in between the shutdown and remount?
> > > 
> > > No.
> > > 
> > > XFS (dm-3): Mounting Filesystem
> > > XFS (dm-3): Starting recovery (logdev: internal)
> > > XFS (dm-3): Ending recovery (logdev: internal)
> > > 
> > >> How many files in that 200GB of data?
> > > 
> > > At 0.9GB/file at least 220.
> > > 
> > >> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

So I can make any sense of the errors, can you please post the
rest of the information this link asks for?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
