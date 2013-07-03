Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBE207F88
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 04:50:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 445E1AC005
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 02:50:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4tKZ64GIq4xr8bxi for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 02:50:55 -0700 (PDT)
Date: Wed, 3 Jul 2013 19:50:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Message-ID: <20130703095050.GN14996@dastard>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
	<20130703064026.GL14996@dastard>
	<c229feab100a72240128ef81297680a1@meuh.org>
	<20130703092406.GM14996@dastard>
	<5e9d66217e0fa968863177d73dd492b1@meuh.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5e9d66217e0fa968863177d73dd492b1@meuh.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Jul 03, 2013 at 11:36:39AM +0200, Yann Droneaud wrote:
> Le 03.07.2013 11:24, Dave Chinner a =E9crit=A0:
> >On Wed, Jul 03, 2013 at 10:14:41AM +0200, Yann Droneaud wrote:
> >>Le 03.07.2013 08:40, Dave Chinner a =E9crit=A0:
> >>>On Tue, Jul 02, 2013 at 05:00:47PM +0200, Yann Droneaud wrote:
> >>>>This patch changes type of xfs@oss.sgi.com
> >>>>
> >>>>The output of ./scripts/get_maintainer.pl is
> >>>>modified to report xfs@oss.sgi.com as a list:
> >>>
> >>>What's the problem with that? All XFS patches and problem
> >>>reports should be sent to the xfs@oss.sgi.com list. There are far
> >>>more people than just the maintainer that can triage problems,
> >>>answer questions and review patches...
> >>>
> >>
> >>It was just disturbing: I was looking for a list for XFS
> >>and found only maintainers.
> >
> >That's what the:
> >
> >L:      xfs@oss.sgi.com
> >
> >entry is, yes?
> >
> =

> In the output of ./scripts/get_maintainer.pl:
> =

> Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
> Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
> xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
> linux-kernel@vger.kernel.org (open list)

You're smarter than a dumb script. If the information that the
script parses is correct and the dumb script doesn't give you the
right information, then what needs fixing?

Seriously, all you are proving is the old adage that
scripts/get_maintainer.pl should be considered harmful because
people use it without first engaging their brain.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
