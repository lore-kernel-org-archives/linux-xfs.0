Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UJp6N0019353 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 14:51:06 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA9281B9F4A3
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 12:51:44 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id nS1A37R6vBgn3Umc for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 12:51:44 -0700 (PDT)
Date: Tue, 31 Aug 2010 05:51:37 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1123090185.486021283197897549.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1283178097.5273.97.camel@doink>
Subject: Re: Review: xfsprogs with libblkid enabled for Debian
MIME-Version: 1.0
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
To: aelder@sgi.com
Cc: xfs <xfs@oss.sgi.com>


----- "Alex Elder" <aelder@sgi.com> wrote:

> > > Next week also has Alex back from vacation, so I'd suggest waiting
> > > if he has any input on this.
> > 
> > As discussed on IRC, I made the changes and push out a new release.sh
> > tagged git update to kernel.org.  I pushed the src tarball to oss also,
> > and libblkid enabled packages will be uploaded to Debian shortly.
> 
> Sorry I didn't get this done for you last week.  I hadn't looked

Not a problem.

> over the patch closely yet and didn't notice you were proposing
> a new release.
> 
> Now that I've looked, I can say the changes all look fine to me.
> I'm glad you broke up your recent patch into multiple commits.
> 
> I will publish your versioned release on oss.sgi.com today after
> my tests complete.

Great, thanks.  You'll find there is a src tarball on oss already, in
what looked like the usual spot that you put 'em.  If, while testing,
you come across something else that needs to change, pls bump version
again before releasing - thanks!

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
