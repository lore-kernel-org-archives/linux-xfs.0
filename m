Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAANVdYn004892 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 17:31:39 -0600
Subject: Re: [PATCH 2/2] xfsprogs: update deb package maintainer, bump version
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <477680717.25681289427570428.JavaMail.root@acxmail-au2.aconex.com>
References: <477680717.25681289427570428.JavaMail.root@acxmail-au2.aconex.com>
Date: Wed, 10 Nov 2010 17:32:10 -0600
Message-ID: <1289431930.1925.14.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, Anibal@oss.sgi.com, Monsalve Salazar <anibal@debian.org>, xfs <xfs@oss.sgi.com>

On Thu, 2010-11-11 at 09:19 +1100, Nathan Scott wrote:
> Hi Alex,
> 
> ----- "Alex Elder" <aelder@sgi.com> wrote:
> 
> > On Wed, 2010-11-10 at 10:53 +1100, Nathan Scott wrote:
> > > No worries - do you have an ETA there Alex?
> > 
> > I wanted to update them and re-post and get
> > an actual review this time.
> > 
> > I can get that done with a few hours effort.
> > What is your time frame?  I'm in the middle of a
> > few things right now but can move this to the
> > front of my queue if you're short on time.
> 
> Ideally we'd get a release out asap for Debian folks,
> as the upgrade issue is biting quite a few people.  If
> the metadump stuff needs more time, doing a subsequent
> release with that is a fine option too... lemme know.
> Since Debian is moving toward a (distro) release, the
> less change we're putting into this release, the better
> - so, my vote would be to hold off on further changes
> till next time, but up to you.

Fine with me.  The metadump stuff doesn't need much time
but I don't mind marking a release without it.  Push your
changes to the xfsprogs-dev tree and I'll put together
the release first thing tomorrow.

I'm not sure where you sent these patches the first time
but I seem to have missed them.  In the future please
send this sort of thing to the list for review.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
