Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 11:19:38 -0700 (PDT)
Received: from mail.parisc-linux.org ([192.25.206.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6GIJYbm015377
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 11:19:35 -0700
Date: Mon, 16 Jul 2007 11:48:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Advocacy] Re: 3ware 9650 tips
Message-ID: <20070716174801.GM13826@parisc-linux.org>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <alpine.LRH.0.999.0707161142440.25773@chaos.egr.duke.edu> <1184606132.4551.11.camel@portatux64.mobile.smithconcepts.com> <200707162040.00062.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707162040.00062.a1426z@gawab.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Boldi <a1426z@gawab.com>
Cc: "Bryan J. Smith" <b.j.smith@ieee.org>, Joshua Baker-LePain <jlb17@duke.edu>, David Chinner <dgc@sgi.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Mon, Jul 16, 2007 at 08:40:00PM +0300, Al Boldi wrote:
> XFS surely rocks, but it's missing one critical component: data=ordered
> And that's one component that's just too critical to overlook for an 
> enterprise environment that is built on data-integrity over performance.
> 
> So that's the secret why people still use ext3, and XFS' reliance on external 
> hardware to ensure integrity is really misplaced.
> 
> Now, maybe when we get the data=ordered onto the VFS level, then maybe XFS 
> may become viable for the enterprise, and ext3 may cease to be KING.

Wow, thanks for bringing an advocacy thread onto linux-fsdevel.  Just what
we wanted.  Do you have any insight into how to "get the data=ordered
onto the VFS level"?  Because to me, that sounds like pure nonsense.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
