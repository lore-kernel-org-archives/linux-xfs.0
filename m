Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F21C97FA7
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 13:34:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BEF288F8065
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 11:34:26 -0800 (PST)
Date: Fri, 8 Nov 2013 11:34:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS leadership and a new co-maintainer candidate
Message-ID: <20131108193424.GA11052@infradead.org>
References: <20131107220208.GY1935@sgi.com> <527C0F64.3010906@sgi.com>
	<527C4B27.6020205@redhat.com> <527CC50D.4060905@redhat.com>
	<20131108180337.GO10553@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131108180337.GO10553@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: elder@kernel.org, Mark Tinguely <tinguely@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>

On Fri, Nov 08, 2013 at 12:03:37PM -0600, Ben Myers wrote:
> Mark is replacing Alex as my backup because Alex is really busy at
> Linaro and asked to be taken off awhile ago.  The holiday season is
> coming up and I fully intend to go off my meds, turn in to Fonzy the
> bear, and eat my hat.  I need someone to watch the shop while I'm off
> exploring on Mars.  I trust Mark to do that because he is totally
> awesome.


Doing this as an unilateral decisions is not something that will win you
a fan base.

While we never had anything reassembling a democracy in Linux Kernel
development making decisions without even contacting the major
contributor is wrong, twice so if the maintainer is a relatively minor
contributor to start with.

Just because it recent came up elsewhere I'd like to recite the
definition from Trond here again:

	http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000066.html

By many of the creative roles enlisted there it's clear that Dave should
be the maintainer.  He's been the main contributor and chief architect
for XFS for many year, while the maintainers came and went at the mercy
of SGI.  This is not meant to bad mouth either of you as I think you're
doing a reasonably good job compared to other maintainers, but at the
same time the direction is set by other people that have a much longer
involvement with the project, and having them officially in control
would help us forward a lot.  It would also avoid having to spend
considerable resources to train every new generation of SGI maintainer.

Coming to and end I would like to maintain Dave Chinner as the primary
XFS maintainer for all the work he has done as biggest contributor and
architect of XFS since longer than I can remember, and I would love to
retain Ben Myers as a co-maintainer for all the good work he has done
maintaining and reviewing patches since November 2011.

I would also like to use this post as a public venue to condemn the
unilateral smokey backroom decisions about XFS maintainership that
SGI is trying to enforce on the community.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
