Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8J7Vo6050304 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 13:07:32 -0600
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id YMMfBVTzQ20KFTMt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 08 Dec 2012 11:09:58 -0800 (PST)
Received: by mail-pa0-f53.google.com with SMTP id hz1so1100680pad.26
	for <xfs@oss.sgi.com>; Sat, 08 Dec 2012 11:09:58 -0800 (PST)
Date: Sat, 8 Dec 2012 11:12:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
Message-ID: <20121208191212.GA3592@kroah.com>
References: <20121203144208.143464631@sgi.com> <20121205214505.GG29399@dastard>
	<50C0D57A.9000704@sgi.com> <20121207100646.GJ27172@dastard>
	<20121207211536.GW27055@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121207211536.GW27055@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

On Fri, Dec 07, 2012 at 03:15:36PM -0600, Ben Myers wrote:
> Stable folk (cc'd Greg), what is your disposition with regard to proposing
> patches for -stable proactively?  Do we really need to have a bug report from a
> 3.0-stable user for every bug we propose for 3.0-stable?

My rules are if the subsystem maintainer(s) agree that the patches
should be applied, and they meet the stable tree guidelines, then I
accept them.  So it's up to you all, I'll do whatever you suggest here.

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
