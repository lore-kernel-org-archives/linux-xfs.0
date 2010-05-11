Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4BFAfnF096343 for <xfs@oss.sgi.com>; Tue, 11 May 2010 10:10:41 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 547A11561668
	for <xfs@oss.sgi.com>; Tue, 11 May 2010 08:13:18 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id gogUyXArgCMgcbGv for <xfs@oss.sgi.com>;
	Tue, 11 May 2010 08:13:18 -0700 (PDT)
Date: Tue, 11 May 2010 08:12:08 -0700
From: Greg KH <gregkh@suse.de>
Subject: Re: [77/98] xfs: add a shrinker to background inode reclaim
Message-ID: <20100511151208.GI14895@suse.de>
References: <20100510223541.333994587@kvm.kroah.org>
	<1273589240.2674.15.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1273589240.2674.15.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, stable-review@kernel.org, Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable@kernel.org, alan@lxorguk.ukuu.org.uk

On Tue, May 11, 2010 at 09:47:20AM -0500, Alex Elder wrote:
> On Mon, 2010-05-10 at 15:35 -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> Acked-by: Alex Elder <aelder@sgi.com>

Thanks, I've added your ack for both the .32 and .33 versions of this
patch.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
