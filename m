Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oABGNQ7W060799 for <xfs@oss.sgi.com>; Thu, 11 Nov 2010 10:23:26 -0600
Subject: Re: [PATCH 2/2] xfsprogs: update deb package maintainer, bump version
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1277374387.31511289471057155.JavaMail.root@acxmail-au2.aconex.com>
References: <1277374387.31511289471057155.JavaMail.root@acxmail-au2.aconex.com>
Date: Thu, 11 Nov 2010 10:24:33 -0600
Message-ID: <1289492673.2280.15.camel@doink>
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
To: nathans@aconex.com
Cc: xfs <xfs@oss.sgi.com>

On Thu, 2010-11-11 at 21:24 +1100, nathans@aconex.com wrote:
> ----- "Nathan Scott" <nathans@aconex.com> wrote:
> 
> > ----- "Alex Elder" <aelder@sgi.com> wrote:
> > 
> > > On Thu, 2010-11-11 at 09:19 +1100, Nathan Scott wrote:
> > > > Hi Alex,
> > > > ...
> > > > - so, my vote would be to hold off on further changes
> > > > till next time, but up to you.
> > > 
> > > Fine with me.  The metadump stuff doesn't need much time
> > > but I don't mind marking a release without it.  Push your
> > > changes to the xfsprogs-dev tree and I'll put together
> > > the release first thing tomorrow.
> > 
> > OK, will get that done tonight (local time, in ~5hrs or so).
> 
> Merged, tagged, pushed to kernel.org and Debian servers.  Lemme
> know if you'd like me to spin up a source tarball to put on ftp
> area of oss.sgi.com, etc, too.

You apparently didn't use the release script.  I'm not
going to change anything though--I expect a new version
should be tagged once I get the metadump changes in and
that will be pretty soon anyway.

I'll update the git tree on oss.sgi.com and will push a
tar file out to oss.sgi.com, you don't have to.

Thanks.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
