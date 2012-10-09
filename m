Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99MrhwO119955 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 17:53:43 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tNtY3PEMiteqz2ab for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 15:55:13 -0700 (PDT)
Date: Wed, 10 Oct 2012 09:54:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/14] xfs: xfs_sync_data is redundant.
Message-ID: <20121009225450.GT23644@dastard>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<1349693772-8064-7-git-send-email-david@fromorbit.com>
	<20121009210124.GT13214@sgi.com> <20121009212851.GP23644@dastard>
	<20121009214144.GU13214@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121009214144.GU13214@sgi.com>
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
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 04:41:44PM -0500, Ben Myers wrote:
> Hey,
> 
> On Wed, Oct 10, 2012 at 08:28:51AM +1100, Dave Chinner wrote:
> > On Tue, Oct 09, 2012 at 04:01:24PM -0500, Ben Myers wrote:
> > > Hi Brain,
> > 
> > [Pinky: "Gee, Brain, what do you want to do tonight?"
> >  Brain: "The same thing we do every night, Pinky - try to take over
> >         the world!"]
> 
> Wish I could say I called him 'brain' on purpose.  Will you be playing the part
> of Pinky in today's show?  ;)

I think so, Brain, but what if the badger won't hold the fork steady
for long enough? :)

Cheers,

Dave.

PS: for those that don't get it, google AYPWIP....
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
