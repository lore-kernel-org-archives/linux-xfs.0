Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UEL3hB007381 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 09:21:03 -0500
Subject: Re: Review: xfsprogs with libblkid enabled for Debian
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <239606566.371721282829201737.JavaMail.root@mail-au.aconex.com>
References: <239606566.371721282829201737.JavaMail.root@mail-au.aconex.com>
Date: Mon, 30 Aug 2010 09:21:37 -0500
Message-ID: <1283178097.5273.97.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Nathan Scott <nathans@aconex.com>
Cc: xfs <xfs@oss.sgi.com>

On Thu, 2010-08-26 at 23:26 +1000, Nathan Scott wrote:
> ----- "Christoph Hellwig" <hch@infradead.org> wrote:
> 
> > I'm fine with pushing out a new 3.1.3 release as it's time anyway,
> > but
> > can we also include Dave's patch to add XFS_IOC_ZERO_RANGE support to
> > xfs_io and the xfsctl manpage first?
> > 
> > Next week also has Alex back from vacation, so I'd suggest waiting if
> > he has any input on this.
> 
> As discussed on IRC, I made the changes and push out a new release.sh
> tagged git update to kernel.org.  I pushed the src tarball to oss also,
> and libblkid enabled packages will be uploaded to Debian shortly.

Sorry I didn't get this done for you last week.  I hadn't looked
over the patch closely yet and didn't notice you were proposing
a new release.

Now that I've looked, I can say the changes all look fine to me.
I'm glad you broke up your recent patch into multiple commits.

I will publish your versioned release on oss.sgi.com today after
my tests complete.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
