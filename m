Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B8egG9073228 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 03:40:43 -0500
Received: from mail-out3.booking.com (mail-out3.booking.com [91.195.237.20])
	by cuda.sgi.com with ESMTP id M2uy6nIGINxlTNZm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 01:42:14 -0700 (PDT)
Date: Thu, 11 Oct 2012 10:42:20 +0200
From: Marcin Deranek <marcin.deranek@booking.com>
Subject: Re: Performance degradation over time
Message-ID: <20121011104220.133383dc@booking.com>
In-Reply-To: <20121010233704.GC23644@dastard>
References: <20121010105142.148519ca@booking.com>
	<20121010233704.GC23644@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 11 Oct 2012 10:37:04 +1100
Dave Chinner <david@fromorbit.com> wrote:

> Use a more recent distro. I reworked the metadata caching algorithms
> a couple of years ago to avoid these sorts of problems with memory
> reclaim.

I can give a shot CentOS 6.x although that might take some time..

Marcin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
