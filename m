Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8D787F90
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 19:54:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7AE7304053
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 17:54:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	G629DE1ezTHJLiSc for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 17:54:18 -0700 (PDT)
Date: Sat, 9 Aug 2014 10:54:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Verifier fixes backported to stable kernels?
Message-ID: <20140809005404.GG26465@dastard>
References: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 08, 2014 at 09:23:46PM +0200, Fanael Linithien wrote:
> Will the verifier fixes get backported to 3.15 and/or 3.16, or do we
> have to wait for 3.17?

What fixes are you talking about? List of commits, please, noting
whether the commit already has a "cc: <stable@vger.kernel.org>" in
it or not.

> I don't want to wait for 3.17. My / has just been eaten by this bug,
> and I'm reluctant to reinstall until it's fixed.

Patch your kernel with the fixes you've identified are necessary,
then - it can take some time for fixes to propagate through the
stable process....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
